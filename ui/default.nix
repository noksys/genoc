# UI aggregator: desktop environment selector + on/off toggles for the
# always-on UI bits (fonts, kmscon TTY, console editors). Each per-DE
# file (kde.nix, gnome.nix, lxqt.nix) gates its content on
# genoc.ui.desktop; this file only declares the option universe.
{ config, lib, ... }:

with lib;

{
  imports = [
    ./kde.nix
    ./gnome.nix
    ./lxqt.nix
    ./fonts.nix
    ./terminal.nix
    ./kmscon.nix
  ];

  options.genoc.ui = {
    desktop = mkOption {
      type = types.enum [ "none" "kde" "gnome" "lxqt" ];
      default = "none";
      description = ''
        Desktop environment. "none" leaves the system headless (no
        xserver, no SDDM/GDM); pick a DE to set up the display server,
        login manager, and the corresponding services.* / programs.*.
      '';
    };

    fonts.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Install the always-on system fonts bundle.";
    };

    kmscon.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Use kmscon as KMS-based virtual terminal (replaces agetty on TTYs).";
    };

    consoleEditors.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Install console-grade editor/web/multimedia tools (links2, lynx,
        w3m, mplayer, fontforge, otf2bdf, terminus_font, …) plus the
        TTY-only "text" specialisation that disables the X server.
      '';
    };
  };
}
