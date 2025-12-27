{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./grub.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      #efiInstallAsRemovable = true;
      enableCryptodisk = true;
      memtest86.enable = true;
      devices = [ "nodev" ];
      device = lib.mkForce "nodev";
    };
  };
}
