{ pkgs, ... }:
{
  imports = [ ./music.nix ];

  environment.systemPackages = with pkgs; [
    sox # Provides "play" CLI for quick audio playback/testing
  ];
}
