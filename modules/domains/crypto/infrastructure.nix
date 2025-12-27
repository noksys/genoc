{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bitcoin-knots
    electrs
    elements
    namecoind
    ncdns
  ];
}
