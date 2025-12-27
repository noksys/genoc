{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/office/full.nix # LaTeX, Pandoc
    ../../modules/domains/office/pdf-tools.nix
    ../../modules/ui/fonts/ultimate.nix
  ];
}
