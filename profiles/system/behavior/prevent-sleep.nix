{ pkgs, ... }:

{
  imports = [
    ../../../policies/power/restrictions/no_sleep.nix
  ];
}
