{ pkgs, ... }: { environment.systemPackages = [ pkgs.wineWow64Packages.stable pkgs.winetricks ]; }
