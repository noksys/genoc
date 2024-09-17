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
  htop
  jq
  keepassxc
  ledger
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
