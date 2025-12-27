{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/office/regular.nix
    ../../modules/domains/science/research.nix
    ../../modules/domains/education/base.nix
  ];
}