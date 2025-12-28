{ pkgs, ... }:

{
  imports = [ ./regular.nix ];

  environment.systemPackages = with pkgs; [
    xonotic     # Fast-paced FPS
    assaultcube # Lightweight FPS
    frozen-bubble # Puzzle game
    nethack     # Classic roguelike
  ];
}
