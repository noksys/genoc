# SDDM 2FA: password + YubiKey touch (no PIN at the GUI). Other PAM
# stacks (login/TTY) are intentionally untouched.
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.security.sddmU2f.enable = mkOption {
    type = types.bool;
    default = true;
    description = "SDDM 2FA via YubiKey (FIDO U2F).";
  };

  config = mkIf config.genoc.security.sddmU2f.enable {
    security.pam.services.sddm.u2fAuth = false;  # keep helper wiring off
    security.pam.services.login.u2fAuth = false; # leave TTY/login unchanged

    security.pam.services.sddm.text = lib.mkForce ''
      auth      required   ${pkgs.pam_u2f}/lib/security/pam_u2f.so \
                cue origin=pam://sddm appid=pam://sddm debug
      auth      substack   login
      account   include    login
      password  substack   login
      session   include    login
    '';
  };
}
