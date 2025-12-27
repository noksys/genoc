{ pkgs, ... }: { networking.wireguard.enable = true; environment.systemPackages = [ pkgs.wireguard-tools ]; }
