# Display color calibration tooling.
#
# DisplayCAL drives a colorimeter (e.g. ColorHug, X-Rite i1Display Pro)
# to generate ICC profiles for the panel; ArgyllCMS is the underlying
# CLI suite DisplayCAL uses. KDE's GUI for applying ICC profiles
# (kdePackages.colord-kde) is set up in genoc/ui/kde.nix.
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.hardware.colorCalibration.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf config.genoc.hardware.colorCalibration.enable {
    environment.systemPackages = with pkgs; [
      displaycal
      argyllcms
    ];
  };
}
