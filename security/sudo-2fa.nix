# Second factor for sudo: YubiKey touch locally, TOTP when the key is away.
#
# Scope, stated up front: pam_u2f proves PRESENCE, not consent to a specific
# command. The PAM prompt never shows what is about to run, so a script with a
# buried `sudo` makes the key blink for something the user cannot see. This is
# therefore half a control; the other half is whatever layer displays the command
# before asking. Neither is sufficient alone.
#
# Why oath is forced to "sufficient" (see rules block below): this user's account
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
{ config, lib, pkgs, ... }:
with lib;
{
  options.genoc.security.sudo2fa.enable = mkOption {
    type = types.bool;
    default = false; # genoc is shared across machines: opt in per machine
    description = "Require a YubiKey touch (or a TOTP code) for sudo.";
  };

  config = mkIf config.genoc.security.sudo2fa.enable {
    security.pam.u2f = {
      enable = true;
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
      enable = true;
      digits = 6;
      window = 2; # tolerate clock drift
    };

    security.pam.services.sudo = {
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
