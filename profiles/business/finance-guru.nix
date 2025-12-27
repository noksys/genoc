{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/finance/full.nix # Hledger + Paisa + GnuCash
    ../../modules/domains/crypto/wallets.nix
    ../../modules/domains/crypto/infrastructure.nix
  ];

  environment.systemPackages = with pkgs; [
    galculator
    libreoffice-calc
  ];
}
