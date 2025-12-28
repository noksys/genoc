{ pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  environment.systemPackages = with pkgs; [
    valgrind # Memory debugging and profiling
    elfutils # ELF utilities (readelf, eu-*)
  ];
}
