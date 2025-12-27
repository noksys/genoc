{ pkgs, ... }:

{
  imports = [
    ../../modules/web/browsers/mainstream.nix
    ../../modules/web/browsers/exotic.nix
  ];
}
