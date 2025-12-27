{ pkgs, ... }:
{
  imports = [ ./apps-base.nix ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks          # Tweak Tool for GNOME Shell
    gnome-extension-manager # Manage GNOME Shell Extensions
    eog                   # Image Viewer (Eye of GNOME)
    evince                # Document Viewer
    file-roller           # Archive Manager
    gnome-calculator      # Calculator
    baobab                # Disk Usage Analyzer
    gnome-disk-utility    # Disks
  ];
}