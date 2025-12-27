{ pkgs, ... }: { environment.systemPackages = [ pkgs.python3Packages.tensorflow ]; }
