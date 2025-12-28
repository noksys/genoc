{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bitcoin-knots # Bitcoin full node (Knots)
    electrs       # Electrum server
    elements      # Elements daemon
    namecoind     # Namecoin daemon
    ncdns         # Namecoin DNS bridge
  ];
}
