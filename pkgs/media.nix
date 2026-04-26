{ pkgs }:

# Always-on media consumer tools. Creator-grade apps (GIMP, Krita,
# Inkscape, Kdenlive, OBS, Blender, FreeCAD, Audacity, Ardour, …) live
# in the media-creator profile.

with pkgs; [
  feh                     # lightweight image viewer
  flameshot               # screenshot tool with annotations
  imagemagick             # convert / mogrify / display
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
]
