{ pkgs, ... }: { imports = [ ./java-base.nix ]; environment.systemPackages = [ pkgs.scala pkgs.sbt ]; }
