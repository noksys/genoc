{ pkgs }:

with pkgs; [
  #terminator don't work well with KDE+Wayland
  appimage-run
  appimagekit
  bash
  bc
  beep
  calibre
  certbot
  clickup
  gawk
  ghostscript
  gnucash
  htop
  jq
  kcalc
  keepassxc
  kitty
  kuro
  ledger
  libreoffice
  mermaid-cli
  p7zip
  parted
  patch
  poppler_utils
  screen
  speedcrunch
  sqlite
  sqlitebrowser
  tmux
  veracrypt
  virt-manager
  waydroid
  wkhtmltopdf
  wl-clipboard
  wxmaxima
  xlockmore
  xorg.xmessage
]
