{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/office/regular.nix
    ../../modules/domains/social/communication.nix
    ../../modules/ui/fonts/ms-compat.nix
  ];
}
