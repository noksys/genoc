{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  boot.loader.grub = {
    enable = true;
    device = "${vars.bootDevice}";
    useOSProber = true;
  };
}

