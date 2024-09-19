{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # Don't forget to run:
    # sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
    # sudo nix-channel --update

    <nixos-hardware/lenovo/legion/16irx8h>
    ./baremetal.nix
  ];

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      nvtopPackages.intel
    ])
  ];
}
