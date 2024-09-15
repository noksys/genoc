{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../../hardware-configuration.nix
    ../sound/pipewire.nix
  ];

  # Virtualization
  virtualisation.vmware.guest.enable = false;
}
