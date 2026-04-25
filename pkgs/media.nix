{ pkgs }:

with pkgs; [
  ardour                  # DAW (digital audio workstation)
  audacity
  blender                 # 3D suite
  darktable               # photography / RAW workflow
  dia
  drawing                 # simple Paint-like editor (GNOME-friendly)
  feh                     # lightweight image viewer
  ffmpeg_6-full
  flameshot               # screenshot tool with annotations
  freecad                 # parametric CAD
  gimp-with-plugins
  imagemagick
  inkscape-with-extensions
  kdePackages.kdenlive    # non-linear video editor
  kdePackages.kolourpaint
  meshlab                 # mesh processing
  mpv
  obs-studio
  optipng
  pick-colour-picker
  pngquant
  scribus                 # desktop publishing
  simple-scan             # SANE scanning frontend
  zathura                 # keyboard-driven document viewer

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
