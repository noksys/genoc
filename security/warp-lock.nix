# Put Cloudflare WARP behind sudo, so connecting to the corporate network needs a
# human (and, with genoc.security.sudo2fa, a YubiKey touch or a TOTP code).
#
# Why the directory and not the socket: warp-svc recreates its socket at every
# start and it lands as 0777, so anything running as any user can speak the
# control protocol to it directly — restricting the warp-cli binary would achieve
# nothing. Traversal permission on the parent directory gates access regardless of
# the socket's own mode.
#
# The unit already declares RuntimeDirectory=cloudflare-warp, which means systemd
# creates /run/cloudflare-warp itself, owned by the unit's user (root). Setting the
# mode is therefore all that is needed: 0750 leaves it root-only, so `warp-cli`
# fails for a normal user and `sudo warp-cli` works.
#
# An earlier version of this module did the same job with
# `ExecStartPost=chgrp warp-admin`, and that was wrong twice over. The unit ships
# with CapabilityBoundingSet=cap_net_bind_service cap_net_admin cap_sys_ptrace,
# so CAP_CHOWN is absent and chgrp is denied even running as root — the failure
# takes the whole unit down with it, leaving WARP in a restart loop. It also
# raced against warp-svc creating the directory. RuntimeDirectoryMode has neither
# problem: it is declarative, applied at creation, and needs no group.
#
# Known cost: warp-taskbar runs as the desktop user and talks to the same socket,
# so the tray applet cannot work. There is no way to keep it and still gate the
# service — whoever can reach the socket can control the connection. Use
# `sudo warp-cli status` instead.
#
# The applet must therefore be masked, not merely left broken: the package ships
# an XDG autostart entry (`systemctl --user start warp-taskbar`) and a unit with
# Restart=always, so an unmasked warp-taskbar retries the socket once per second
# for the whole session, logging an ERROR line each time — about a third of the
# journal, crowding real logs out of retention. Masking the user unit makes that
# autostart fail instantly and silently.
#
# This is a local control, so it is only as strong as the sudo in front of it. The
# durable version lives on the Cloudflare side, as a Zero Trust device policy: it
# survives package updates, which this may not.
{ config, lib, pkgs, ... }:
with lib;
{
  options.genoc.security.warpLock.enable = mkOption {
    type = types.bool;
    default = false; # genoc is shared across machines: opt in per machine
    description = "Require root (hence sudo) to connect or disconnect Cloudflare WARP.";
  };

  config = mkIf config.genoc.security.warpLock.enable {
    systemd.services.cloudflare-warp.serviceConfig.RuntimeDirectoryMode = "0750";
    systemd.user.units."warp-taskbar.service".enable = false;
  };
}
