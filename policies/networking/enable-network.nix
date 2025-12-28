{ config, lib, pkgs, ... }:

let
  vars = import ../../../../custom_vars.nix;
in
{
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  users.users.${vars.mainUser}.extraGroups = [ "networkmanager" ];
}