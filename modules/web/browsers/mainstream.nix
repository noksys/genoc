{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox       # Firefox browser
    google-chrome # Google Chrome
  ];
}
