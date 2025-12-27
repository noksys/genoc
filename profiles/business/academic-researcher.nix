{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/science/research.nix
    ../../modules/domains/office/full.nix
    ../../modules/ui/fonts/core.nix
  ];
}
