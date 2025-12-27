{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox
    google-chrome
  ];
}
