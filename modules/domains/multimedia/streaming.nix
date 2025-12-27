{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obs-studio
    obs-studio-plugins.wlrobs
    chatterino2
  ];
}
