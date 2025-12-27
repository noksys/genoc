{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ../../policies/power/cpu/balance.nix
  ];
}
