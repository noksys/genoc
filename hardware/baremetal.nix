{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../../hardware-configuration.nix
    ../sound/pulseaudio.nix
  ];

  # Virtualization
  virtualisation.vmware.guest.enable = false;
}
