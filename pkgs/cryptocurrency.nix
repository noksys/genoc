{ pkgs }:

with pkgs; [
  #bisq-desktop
  #electron-cash
  bitcoin
  electrs
  #electrum  # it's better to use the AppImage directly
  elements
  namecoind
  ncdns
]
