{ config, lib, pkgs, modulesPath, ... }:

let
  unstable = import <nixos-unstable> {
    config.allowUnfree = true;
  };
in
{
  nixpkgs.config.packageOverrides = oldPkgs: {
    emacs30-x11 = unstable.emacs30;
    emacs30-pgtk = unstable.emacs30-pgtk;
  };

  environment.systemPackages = with pkgs; [
    emacs30-x11
    emacs30-pgtk

    # Nerd Fonts (new syntax for NixOS ≥ 25.05)
    # Add or remove fonts as desired
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code

    cmake
    libtool
    pkg-config
    gnumake
    gcc          # stdenv.cc is fine too
    libvterm     # C library required by emacs-libvterm
  ];
}
