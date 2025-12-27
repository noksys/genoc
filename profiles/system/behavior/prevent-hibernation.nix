{ pkgs, ... }:

{
  imports = [
    ../../../policies/power/restrictions/no_hibernation.nix
  ];
}
