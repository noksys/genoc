{ config, pkgs, ... }:

{
  imports = [
    ./hledger/server-full.nix
    ./paisa/server-full.nix
    ./gnucash.nix
  ];
}
