{ pkgs, ... }:
{
  imports = [ ./apps-base.nix ];
  
  environment.systemPackages = with pkgs.kdePackages; [
    kate                  # Advanced Text Editor
    gwenview              # Image Viewer
    okular                # Document Viewer
    spectacle             # Screenshot Capture Utility
    ark                   # Archiving Tool
    kcalc                 # Calculator
    filelight             # Disk Usage Statistics
    krdc                  # Remote Desktop Client
    kruler                # Screen Ruler
    kcolorchooser         # Color Chooser
  ];
}