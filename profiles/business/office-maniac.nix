{ pkgs, ... }:

{
  imports = [
    ./office-rat.nix
    ../../modules/domains/office/full.nix
    ../../modules/domains/office/research.nix
    ../../modules/ui/desktop-entries/productivity.nix
  ];
}
