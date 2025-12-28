{ ... }:

{
  imports = [
    ../../modules/domains/finance/full.nix # Hledger + Paisa + GnuCash
    ../../modules/domains/finance/tools.nix
    ../../modules/domains/crypto/wallets.nix
    ../../modules/domains/crypto/infrastructure.nix
  ];
}
