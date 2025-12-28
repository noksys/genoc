{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    galculator # Scientific calculator
    gnumeric   # Lightweight spreadsheet
    # tradingview # Not in nixpkgs, use browser
  ];
}
