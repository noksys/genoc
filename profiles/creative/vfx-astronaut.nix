{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/multimedia/3d.nix
    ../../modules/domains/multimedia/vfx.nix
    ../../modules/hardware/video/nvidia-drivers.nix # Often needed for rendering
  ];
}
