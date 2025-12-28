{ pkgs, ... }:
{
  imports = [
    ./base.nix
    ./music.nix
  ];
  
  environment.systemPackages = with pkgs; [
    # --- Light Editing ---
    gimp                  # The GNU Image Manipulation Program
    inkscape              # Vector graphics editor
    audacity              # Sound editor with graphical UI
    drawing               # A simple image editor for Linux (Paint-like)
    simple-scan           # Simple scanning utility
    flameshot             # Powerful yet simple to use screenshot software
  ];
}
