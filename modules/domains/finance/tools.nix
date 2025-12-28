{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    galculator       # Lightweight scientific calculator
    libreoffice      # Office suite (Calc included)
  ];
}
