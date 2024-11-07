{ pkgs }:

with pkgs; [
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
  kuro
  ledger
  libreoffice
  p7zip
  parted
  patch
  screen
  sqlite
  sqlitebrowser
  #terminator don't work well with KDE+Wayland
  veracrypt
  virt-manager
  waydroid
  wl-clipboard
  xlockmore
  xorg.xmessage
]
