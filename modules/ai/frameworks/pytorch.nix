{ pkgs, ... }: { environment.systemPackages = [ pkgs.python3Packages.torch pkgs.python3Packages.torchvision ]; }
