{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    galculator
    gnumeric
    # tradingview # Not in nixpkgs, use browser
  ];
}
