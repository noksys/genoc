{ pkgs }:

with pkgs; [
  cachix         # binary cache CLI (push/use community caches)
  home-manager   # per-user dotfiles manager
  nix-index      # build the locate-style db for nix-locate
  nixos-option   # query NixOS option values from CLI
]
