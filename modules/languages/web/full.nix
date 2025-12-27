{ pkgs, ... }:
{
  imports = [
    ./node.nix
    ./tools.nix
    ./frontend.nix
    ./styling.nix
  ];
}
