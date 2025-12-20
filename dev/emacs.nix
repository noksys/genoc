{ config, lib, pkgs, modulesPath, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs

    # Nerd Fonts (new syntax for NixOS ≥ 25.05)
    # Add or remove fonts as desired
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack

    cmake
    libtool
    pkg-config
    gnumake
    gcc          # stdenv.cc is fine too
    libvterm     # C library required by emacs-libvterm

    # Doom dependencies
    ripgrep
    fd
    git
    gcc
    gnumake

    noto-fonts-color-emoji
    gsettings-desktop-schemas
    glib

    drawio
    dia
  ];
}
