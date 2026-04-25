{ pkgs }:

with pkgs; [
  ardour                    # DAW (digital audio workstation)
  audacity                  # multitrack audio editor
  blender                   # 3D suite
  darktable                 # photography / RAW workflow
  drawing                   # simple Paint-like editor (GNOME-friendly)
  feh                       # lightweight image viewer
  ffmpeg_6-full             # ffmpeg 6 with all codecs and protocols
  flameshot                 # screenshot tool with annotations
  freecad                   # parametric CAD
  gimp-with-plugins         # GIMP + the curated plugin set
  imagemagick               # convert / mogrify / display
  inkscape-with-extensions  # Inkscape + extension scripts
  kdePackages.kdenlive      # non-linear video editor
  kdePackages.kolourpaint   # KDE Paint-like editor
  meshlab                   # mesh processing
  mpv                       # mpv media player
  obs-studio                # screencast / streaming
  optipng                   # PNG optimizer
  pick-colour-picker        # GTK color picker
  pngquant                  # lossy PNG compressor
  scribus                   # desktop publishing (InDesign alternative)
  simple-scan               # SANE scanning frontend
  sox                       # `play` and audio swiss-army CLI
  vlc                       # VLC media player
  youtube-music              # third-party YouTube Music desktop
  zathura                   # keyboard-driven document viewer

  # ProjectM update:
  # - 'projectm' (old) has been split since version 4
  # - use 'libprojectm' (library) and/or 'projectm-sdl-cpp' (SDL2 visualizer frontend)
  # - if you specifically want the legacy version 3, use 'projectm_3'
  libprojectm
  projectm-sdl-cpp
  # projectm_3   # uncomment if you need the older version

  noto-fonts-color-emoji    # also pulled by ui/fonts.nix; harmless duplicate
]
