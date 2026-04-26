# Communication profile: messengers, voice chat, mail clients, cloud
# sync clients. Always-on by default.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.comm;
in {
  options.genoc.profile.comm = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      claws-mail        # lightweight Gtk2 mail client
      dino              # XMPP/Jabber client (modern Gtk)
      discord           # Discord official client
      maestral          # Dropbox sync (CLI / daemon)
      maestral-gui      # GTK tray for maestral
      mumble            # low-latency voice chat (open-source TS3 alternative)
      signal-cli        # Signal Messenger CLI
      signal-desktop    # Signal Messenger desktop
      telegram-desktop  # Telegram official Qt client
      vesktop           # third-party Discord client (allows screen-sharing on Linux)
    ];
  };
}
