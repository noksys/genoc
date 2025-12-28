{ pkgs, lib, ... }:
{
  imports = [
    ../kde/plasma.nix
    ../gnome/shell.nix
  ];

  # Force SDDM (KDE) as the display manager
  services.displayManager.sddm.enable = lib.mkForce true;
  services.displayManager.gdm.enable = lib.mkForce false;

  # KDE primary: prefer ksshaskpass to avoid GNOME seahorse conflict
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
}
