{ pkgs, ... }:

{
  imports = [
    ../../modules/web/browsers/privacy.nix
    ../../modules/security/vpn/mullvad.nix
    ../../modules/security/privacy/tor.nix
  ];
}
