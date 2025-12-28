{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    galculator       # Lightweight scientific calculator
    libreoffice-calc # Spreadsheet editor
  ];
}
