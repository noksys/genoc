{ config, lib, pkgs, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    splashImage = ./theme/bg.png;
  };

  boot.loader.timeout = 60;
}
