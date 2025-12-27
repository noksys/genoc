{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/multimedia/vector.nix
    ../../modules/ui/fonts/creative.nix
    ../../modules/ui/fonts/ultimate.nix
  ];
}
