{ pkgs, ... }: { environment.systemPackages = [ pkgs.firecracker pkgs.firectl ]; }
