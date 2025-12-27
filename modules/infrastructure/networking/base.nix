{ config, lib, pkgs, ... }:

let
  vars = import ../../../../custom_vars.nix;
in
{
  networking = {
    enableIPv6 = lib.mkDefault true;

    networkmanager = {
      enable = true;
    };
  };

  users.users.${vars.mainUser}.extraGroups = [ "networkmanager" ];
}
