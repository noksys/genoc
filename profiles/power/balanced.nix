{ pkgs, ... }:

{
  imports = [
    ../../policies/power/cpu/balance.nix
  ];
}
