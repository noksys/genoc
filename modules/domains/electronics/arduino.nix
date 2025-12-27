{ pkgs, ... }: { environment.systemPackages = [ pkgs.arduino pkgs.arduino-cli ]; }
