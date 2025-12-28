{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sox # Provides "play" CLI for quick audio playback/testing
  ];
}
