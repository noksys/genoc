{ pkgs, ... }: { imports = [ ../../modules/hardware/video/base.nix ]; services.xserver.windowManager.i3.enable = true; environment.systemPackages = [ pkgs.i3status pkgs.dmenu ]; }
