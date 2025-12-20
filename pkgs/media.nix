{ pkgs }:

with pkgs; [
  audacity
  dia
  ffmpeg_6-full
  gimp-with-plugins
  imagemagick
  inkscape-with-extensions
  kdePackages.kolourpaint
  obs-studio
  optipng
  pick-colour-picker
  pngquant

  # ProjectM update:
  # - 'projectm' (old) has been split since version 4
  # - use 'libprojectm' (library) and/or 'projectm-sdl-cpp' (SDL2 visualizer frontend)
  # - if you specifically want the legacy version 3, use 'projectm_3'
  libprojectm
  projectm-sdl-cpp
  # projectm_3  # uncomment if you need the older version

  sox
  vlc
  youtube-music
  noto-fonts-color-emoji
]
