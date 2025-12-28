{ pkgs, ... }: { imports = [ ../../modules/hardware/video/base.nix ]; programs.sway.enable = true; environment.systemPackages = [ pkgs.waybar pkgs.wofi ]; }
