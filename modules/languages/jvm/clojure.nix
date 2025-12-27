{ pkgs, ... }: { imports = [ ./java-base.nix ]; environment.systemPackages = [ pkgs.clojure pkgs.leiningen pkgs.joker ]; }
