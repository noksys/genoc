# Media creator profile: GIMP/Inkscape/Krita, Kdenlive/OBS, Audacity/Ardour,
# Blender/FreeCAD, Darktable.
#
# mode = "min" | "full"
#   min  = one of each major category (GIMP, Inkscape, Audacity, Kdenlive,
#          Blender, Darktable)
#   full = + heavyweight alternatives (Krita, Ardour, FreeCAD, MeshLab,
#          OBS, kolourpaint, drawing, ffmpeg_6-full for codec coverage)
#
# Player-style media (vlc, mpv, image viewers, scanner) lives in
# pkgs/media.nix as always-on consumer tools — they're cheap and useful
# regardless of whether you're a creator.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.media-creator;
in {
  options.genoc.profile.media-creator = {
    enable = mkEnableOption "media creator profile";

    mode = mkOption {
      type = types.enum [ "min" "full" ];
      default = "full";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        gimp-with-plugins                 # raster
        inkscape-with-extensions          # vector
        audacity                          # audio editor
        kdePackages.kdenlive              # video editor
        blender                           # 3D suite
        darktable                         # photo workflow
      ];
    }
    (mkIf (cfg.mode == "full") {
      environment.systemPackages = with pkgs; [
        krita                             # raster (alternative)
        ardour                            # DAW
        freecad                           # parametric CAD
        meshlab                           # mesh processing
        obs-studio                        # screencast / streaming
        kdePackages.kolourpaint           # quick paint
        drawing                           # GTK paint
        ffmpeg_6-full                     # full codec/protocol coverage
      ];
    })
  ]);
}
