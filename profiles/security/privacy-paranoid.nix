{ pkgs, ... }:

{
  imports = [
    ../../modules/security/vpn/mullvad.nix
    ../../modules/security/privacy/tor.nix
    ../../modules/security/privacy/i2p.nix
    ../../modules/security/hardening/firejail.nix
  ];

  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
}
