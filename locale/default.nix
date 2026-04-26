# Locale selector. Today only "ptbr" is fully wired; "en-us" and other
# locales would slot in here later as alternative imports.
{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./ptbr.nix
    ./fix_ptbr_cedilla.nix
  ];

  options.genoc.locale = mkOption {
    type = types.enum [ "none" "ptbr" ];
    default = "none";
    description = "System locale + IME defaults.";
  };
}
