{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/office/pdf-pro.nix
    ../../modules/domains/office/regular.nix
    ../../modules/ui/fonts/ms-compat.nix
  ];
}
