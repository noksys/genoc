{ pkgs }:

with pkgs; [
  #bisq-desktop
  #electron-cash
  #bitcoin
  bitcoin-knots
  electrs
  #electrum  # it's better to use the AppImage directly
  elements
  namecoind
  ncdns
]
