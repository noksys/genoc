{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    electrs       # Electrum server
    elements      # Elements daemon
    namecoind     # Namecoin daemon
    ncdns         # Namecoin DNS bridge
  ];
}
