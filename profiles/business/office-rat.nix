{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/office/regular.nix
    ../../modules/domains/social/minimalist.nix
    ../../modules/ui/fonts/ms-compat.nix
  ];
}
