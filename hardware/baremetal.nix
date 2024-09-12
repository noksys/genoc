{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../sound/pipewire.nix
  ];

  # Virtualization
  virtualisation.vmware.guest.enable = false;
}
