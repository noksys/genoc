{ pkgs, ... }:

{
  imports = [
    ../../modules/security/forensics/base.nix
    ../../modules/security/privacy/tor.nix
    ../../modules/security/hardening/firejail.nix
  ];
}
