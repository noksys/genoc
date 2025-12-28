{ config, lib, pkgs, ... }:

let
  vars = import ../../../../custom_vars.nix;
in
{
  networking.networkmanager.enable = false;
  networking.wireless.enable = false;
}