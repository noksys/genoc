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
  htop
  jq
  keepassxc
  kuro
  ledger
  libreoffice
  p7zip
  parted
  patch
  screen
  sqlite
  sqlitebrowser
  veracrypt
  virt-manager
  waydroid
  wl-clipboard
  xlockmore
  xorg.xmessage
]
