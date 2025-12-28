{ pkgs, ... }:

{
  imports = [
    ./regular.nix
  ];

  environment.systemPackages = with pkgs; [
    cmatrix  # Terminal Matrix effect
    pipes-rs # Terminal pipes animation
    polybar  # Status bar
    rofi     # App launcher
  ];
}
