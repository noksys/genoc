{ config, lib, pkgs, ... }:

let
  vars = import ../../../../custom_vars.nix;
in
{
    networking.networkmanager.enable = lib.mkForce false;
    networking.wireless.enable = lib.mkForce false;
}