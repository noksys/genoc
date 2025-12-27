{ pkgs, ... }: { environment.systemPackages = with pkgs; [ perl perl538Packages.PerlTidy ]; }
