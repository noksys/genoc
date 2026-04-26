# Media-consumer profile: media playback, image viewers, screenshot,
# scanner, ffmpeg/imagemagick CLIs, projectm visualizer. Complements
# media-creator (which has the editing apps). Always-on by default.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.media-consumer;
in {
  options.genoc.profile.media-consumer = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      feh                     # lightweight image viewer
      ffmpeg-full             # codec/protocol-complete ffmpeg
      flameshot               # screenshot tool with annotations
      imagemagick             # convert / mogrify / display
      libva                   # VA-API video acceleration runtime
      mpv                     # mpv media player
      optipng                 # PNG optimizer
      pick-colour-picker      # GTK color picker
      pngquant                # lossy PNG compressor
      simple-scan             # SANE scanning frontend
      sox                     # `play` and audio swiss-army CLI
      vlc                     # VLC media player
      youtube-music           # third-party YouTube Music desktop
      zathura                 # keyboard-driven document viewer

      # ProjectM visualizer (lightweight, used as a music visualizer):
      libprojectm
      projectm-sdl-cpp
    ];
  };
}
