{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nautilus              # File Manager
    gnome-terminal        # Terminal
    gedit                 # Text Editor
  ];
}
