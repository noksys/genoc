{ pkgs, ... }: { imports = [ ../../../modules/hardware/video/base.nix ]; programs.hyprland.enable = true; environment.systemPackages = [ pkgs.waybar pkgs.wofi ]; }
