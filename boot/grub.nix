{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  boot.loader.systemd-boot.enable = false;

  boot.loader.grub = {
    enable = true;
    device = "${vars.bootDevice}";
    useOSProber = true;
    splashImage = ./bg.png;
  };

  boot.loader.timeout = 5;
}
