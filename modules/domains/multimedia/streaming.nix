{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obs-studio              # Streaming/recording software
    obs-studio-plugins.wlrobs # Wayland screen capture plugin
    chatterino2             # Twitch chat client
  ];
}
