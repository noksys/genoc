{ pkgs, ... }: { environment.systemPackages = with pkgs; [ lua lua-language-server stylua ]; }
