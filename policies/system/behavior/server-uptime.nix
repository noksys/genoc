{ pkgs, ... }:

{
  imports = [
    ../../../policies/power/restrictions/no_sleep.nix
    ../../../policies/power/restrictions/no_hibernation.nix
  ];
}
