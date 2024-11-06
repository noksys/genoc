{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # Don't forget to run:
    # sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
    # sudo nix-channel --update

    <nixos-hardware/lenovo/legion/16irx8h>
    ./baremetal.nix
  ];

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';

  boot.blacklistedKernelModules = [ "snd_soc_avs" ];

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      nvtopPackages.intel
    ])
  ];
}
