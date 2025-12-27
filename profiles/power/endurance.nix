{ pkgs, ... }:

{
  imports = [
    ../../policies/power/cpu/eco-ultra.nix
  ];
}
