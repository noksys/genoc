{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ../../policies/power/cpu/performance.nix
  ];
}
