{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox       # Firefox browser
    chromium      # Chromium browser
    google-chrome # Google Chrome
  ];
}
