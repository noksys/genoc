# Second factor for sudo (and polkit): YubiKey touch locally, TOTP when the key
# is away.
#
# Scope, stated up front: pam_u2f proves PRESENCE, not consent to a specific
# command. The PAM prompt never shows what is about to run, so a script with a
# buried `sudo` makes the key blink for something the user cannot see. This is
# therefore half a control; the other half is whatever layer displays the command
# before asking. Neither is sufficient alone.
#
# Why oath is forced to "sufficient" (see rules blocks below): this user's account
# password is half typed and half emitted by the YubiKey in static-password mode.
# With the stock NixOS stack oath is "requisite", so losing the key would take out
# BOTH surviving paths at once — the touch and the password — leaving a one-time
# code that cannot stand on its own. Making it sufficient is what keeps a lost key
# recoverable without a rescue boot.
#
# Resulting stack — any single factor grants sudo:
#   u2f  sufficient  -> touch, nothing else asked
#   oath sufficient  -> 6-digit code, nothing else asked
#   unix sufficient  -> password (needs the key for its static half, so in
#                       practice this is a local-only path)
#   deny required
#
# An agent running as this user holds none of the three: it cannot touch the key,
# cannot read /etc/users.oath (root, 0600), and does not have the password.
#
# timestamp_timeout=0 makes one authentication equal one command. With the default
# window a single approved sudo silently covers every sudo for the next minutes,
# which is exactly the opaque-script case this exists to catch.
#
# ---------------------------------------------------------------------------
# WHY security.pam.{u2f,oath}.enable ARE FALSE HERE, AND MUST STAY FALSE
# ---------------------------------------------------------------------------
# Those two flags do not mean "turn the module on". In nixos/modules/security/
# pam.nix they are the *default value* of `security.pam.services.<name>.u2fAuth`
# and `.oathAuth` — for every PAM service on the system. Setting them true is a
# system-wide opt-in, not a knob for this file's two targets.
#
# The first version of this file set both to true and named only sudo. The
# defaults had already reached 25 services each. What that bought, none of it
# intended:
#
#   * kde (the Plasma screen locker) got `auth sufficient pam_u2f` as its first
#     rule. The key lives plugged into the laptop, so the lock screen became one
#     touch. Anyone who opened the lid was in. A lock screen whose factor never
#     leaves the machine is not a lock screen.
#   * login (TTY) got `auth requisite pam_oath` ahead of the password. requisite
#     denies immediately on failure, so a console login started demanding a TOTP
#     code — in exactly the situation you reach for a TTY, which is the GUI being
#     broken and the recovery path mattering.
#   * sddm became touch + TOTP + password, not the "password + touch" that
#     sddm-u2f.nix documents, because its hand-written stack does
#     `auth substack login` and login had inherited oath.
#   * sshd got the same requisite oath while KbdInteractiveAuthentication is off,
#     which leaves that prompt with no way to be answered. Password logins fail.
#     Public-key logins were unaffected.
#   * polkit-1, passwd, chsh, chfn, cups, su, xlock, vlock, useradd/groupadd and
#     the rest of the shadow tooling all picked up both modules silently.
#
# The fix is to leave the defaults alone and name each service. What makes that
# safe is a detail of the same module: the u2f and oath rules read their
# `settings` from `config.security.pam.{u2f,oath}` unconditionally, and consult
# `enable` only to compute the per-service default. So `enable = false` keeps
# every setting below in force (origin, appid, cue, digits, window) and changes
# nothing for the services that opt in by name.
#
# If a future service needs the second factor, add it here by name. Do not flip
# these back to true — the blast radius is the whole PAM tree, and it is silent.
{ config, lib, pkgs, ... }:
with lib;
{
  options.genoc.security.sudo2fa.enable = mkOption {
    type = types.bool;
    default = false; # genoc is shared across machines: opt in per machine
    description = "Require a YubiKey touch (or a TOTP code) for sudo and polkit.";
  };

  config = mkIf config.genoc.security.sudo2fa.enable {
    security.pam.u2f = {
      enable = false; # per-service opt-in only — see the block comment above
      control = "sufficient";
      settings = {
        cue = true; # tell the user the key is waiting for a touch
        # pam_u2f defaults its origin to pam://$HOSTNAME. The credential for sudo
        # is registered under pam://sudo, and a FIDO assertion is bound to the
        # origin it was created for, so leaving the default would make the key
        # silently never match. sddm is unaffected: it pins its own origin in a
        # hand-written stack (see sddm-u2f.nix).
        origin = "pam://sudo";
        appid = "pam://sudo";
      };
    };

    security.pam.oath = {
      enable = false; # per-service opt-in only — see the block comment above
      digits = 6;
      window = 2; # tolerate clock drift
    };

    # The two services that escalate privilege, named explicitly.
    security.pam.services.sudo = {
      u2fAuth = true;
      oathAuth = true;
    };

    # polkit is the GUI half of the same boundary: its "Authentication required"
    # dialog grants admin actions, so leaving it on the password alone while sudo
    # asks for a factor the agent cannot produce would only move the soft spot.
    #
    # Known wrinkle, accepted: pam_u2f announces the touch through PAM_TEXT_INFO,
    # and the KDE polkit agent does not reliably render it. The dialog can sit
    # there looking frozen while the key waits. It falls through to the code and
    # then the password on its own, so nothing is lost but the seconds.
    security.pam.services.polkit-1 = {
      u2fAuth = true;
      oathAuth = true;
    };

    # WARNING, carried over from the NixOS module: security.pam.services.<n>.rules
    # is experimental and subject to breaking changes without notice. Using it means
    # manually monitoring nixos/modules/security/pam.nix across upgrades — a rename
    # here fails closed into a lockout, or worse, silently drops the factor.
    #
    # It is used anyway because the alternative (overriding the whole stack via
    # `text`, as sddm-u2f.nix does) means owning account/password/session too, and
    # those would then stop tracking upstream. This overrides exactly one attribute
    # and leaves the rest of the stack generated.
    security.pam.services.sudo.rules.auth.oath.control = mkForce "sufficient";
    security.pam.services.polkit-1.rules.auth.oath.control = mkForce "sufficient";

    # oath-toolkit used to arrive on PATH as a side effect of
    # security.pam.oath.enable. It is needed to seed and verify /etc/users.oath,
    # so ask for it directly rather than leaning on that flag. pam_u2f (for
    # pamu2fcfg) already comes from profiles/security-tools.nix; naming it here
    # too costs nothing and survives that profile being turned off.
    environment.systemPackages = with pkgs; [
      oath-toolkit
      pam_u2f
    ];

    # The base config sets wheelNeedsPassword = false, which emits NOPASSWD: ALL.
    # sudo then skips authentication entirely and the PAM stack above is never
    # consulted — enabling u2f/oath without this override is purely decorative.
    security.sudo.wheelNeedsPassword = mkForce true;

    security.sudo.extraConfig = ''
      Defaults timestamp_timeout=0
      Defaults timestamp_type=tty

      # Echo asterisks while a secret is typed. Without it the OTP prompt gives no
      # feedback at all, which reads as a frozen terminal. The old pwfeedback
      # overflow (CVE-2019-18634) was fixed long before 1.9.x.
      Defaults pwfeedback
    '';
  };
}
