{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../../custom_vars.nix;
in
{
  imports = [
    ./grub-common.nix
  ];

  boot.loader.systemd-boot.enable = false;

  boot.loader.grub = {
    device = "${vars.bootDevice}";
  };
}
