{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/finance/trading.nix
    ../../modules/domains/finance/full.nix
  ];
}
