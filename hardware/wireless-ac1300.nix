# Realtek RTL8812AU driver (out-of-tree). For USB Wi-Fi dongles using
# the AC1300/AC1200 chipset; not needed on Legion Pro 7 (built-in Intel
# Wi-Fi). Default off; flip on machines that ship one.
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.hardware.wirelessAc1300.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf config.genoc.hardware.wirelessAc1300.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8812au ];
    boot.kernelModules = [ "8812au" ];
  };
}
