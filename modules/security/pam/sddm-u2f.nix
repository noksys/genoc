{ pkgs, lib, ... }:

{
  # SDDM: 2FA = password + YubiKey touch (no PIN at GUI)
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
}
