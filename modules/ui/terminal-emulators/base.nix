{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xterm     # Minimal, widely available X11 terminal
    alacritty # Fast GPU-accelerated terminal
  ];
}
