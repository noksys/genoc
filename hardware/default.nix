# Hardware aggregator. Imports every hardware module so their options
# (genoc.hardware.<name>.{enable,…}) are visible everywhere; each
# module gates its own config via mkIf, so this is cheap.
{ config, lib, ... }:

with lib;

{
  imports = [
    # Per-machine families (mutually exclusive via genoc.hardware.machine).
    ./vmware.nix
    ./baremetal.nix
    ./lenovo-legion-pro7-16irx9h.nix

    # Always-eligible hardware modules (each has its own enable option).
    ./zfs.nix
    ./yubikey.nix
    ./coldcard.nix
    ./openrgb.nix
    ./backlight.nix
    ./color-calibration.nix
    ./bluetooth.nix
    ./no_hibernation.nix
    ./no_sleep.nix
    ./wireless-ac1300.nix
  ];

  options.genoc.hardware.machine = mkOption {
    type = types.enum [ "none" "vmware" "baremetal" "lenovo-legion-pro7-16irx9h" ];
    default = "none";
    description = ''
      Which machine family this build targets. Picks the right
      virtualisation/firmware/driver mix:
        - vmware:                       VMware/VMX guest
        - baremetal:                    generic baremetal essentials
        - lenovo-legion-pro7-16irx9h:   Legion Pro 7 Gen9 (NVIDIA + ALC287
                                        audio patch + RTD3); requires the
                                        nixos-hardware Legion module to be
                                        imported from custom_machine.nix.
    '';
  };
}
