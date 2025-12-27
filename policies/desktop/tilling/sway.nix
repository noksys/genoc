{ pkgs, ... }: { imports = [ ../../hardware/video/base.nix ]; programs.sway.enable = true; environment.systemPackages = [ pkgs.waybar pkgs.wofi ]; }
