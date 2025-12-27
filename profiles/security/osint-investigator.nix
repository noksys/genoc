{ pkgs, ... }:

{
  imports = [
    ../../modules/security/osint/base.nix
    ../../modules/security/privacy/tor.nix
  ];
}
