{ pkgs, ... }:

{
  imports = [
    ../../modules/security/forensics/base.nix
    ../../modules/security/hardening/firejail.nix
  ];
}
