{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./grub-common.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      #efiInstallAsRemovable = true;
      enableCryptodisk = true;
      memtest86.enable = true;
      devices = [ "nodev" ];
      device = lib.mkForce "nodev";
    };
  };
}
