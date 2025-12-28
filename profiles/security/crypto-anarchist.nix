{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/crypto/full.nix
    ../../modules/domains/crypto/privacy-tools.nix
    ../../modules/security/privacy/anonymity.nix
    ../../modules/security/privacy/i2p-advanced.nix
  ];
}
