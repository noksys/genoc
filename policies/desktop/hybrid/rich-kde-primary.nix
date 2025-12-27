{ pkgs, lib, ... }:
{
  imports = [
    ../kde/plasma.nix
    ../gnome/shell.nix
  ];

  # Force SDDM (KDE) as the display manager
  services.displayManager.sddm.enable = lib.mkForce true;
  services.xserver.displayManager.gdm.enable = lib.mkForce false;
}
