# OpenRGB: vendor-agnostic RGB lighting control daemon + udev rules.
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.hardware.openrgb.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf config.genoc.hardware.openrgb.enable {
    services.udev.packages = [ pkgs.openrgb ];
    environment.systemPackages = [ pkgs.openrgb ];
  };
}
