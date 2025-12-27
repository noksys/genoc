{ pkgs, ... }:

{
  imports = [
    ../../modules/languages/python/data-science.nix
    ../../modules/domains/science/research.nix
  ];
}
