{ pkgs, ... }: { imports = [ ./java-base.nix ]; environment.systemPackages = [ pkgs.kotlin pkgs.kotlin-language-server ]; }
