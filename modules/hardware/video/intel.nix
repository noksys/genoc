{ pkgs, ... }: { imports = [ ./base.nix ]; hardware.graphics.extraPackages = [ pkgs.intel-media-driver ]; }
