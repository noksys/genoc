{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/multimedia/regular.nix # Gimp
    ../../modules/domains/multimedia/3d.nix # Blender
    ../../modules/ui/fonts/creative.nix
    ../../modules/hardware/peripherals/openrgb.nix
  ];
}
