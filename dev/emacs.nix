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
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    cmake
    libtool
    pkg-config
    gnumake
    gcc          # (stdenv.cc is fine too)
    libvterm     # the C library required by emacs-libvterm
  ];
}
