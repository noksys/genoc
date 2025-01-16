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
  gawk
  ghostscript
  gnucash
  htop
  jq
  keepassxc
  kitty
  kuro
  ledger
  libreoffice
  p7zip
  parted
  patch
  screen
  sqlite
  sqlitebrowser
  tmux
  veracrypt
  virt-manager
  waydroid
  wl-clipboard
  wxmaxima
  xlockmore
  xorg.xmessage
]
