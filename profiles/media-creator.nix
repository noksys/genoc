# Media creator profile: OBS, Kdenlive, Inkscape, Krita, GIMP+plugins.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.media-creator;
in {
  options.genoc.profile.media-creator = {
    enable = mkEnableOption "media creator profile (video/audio/raster/vector)";
  };

  config = mkIf cfg.enable { };
}
