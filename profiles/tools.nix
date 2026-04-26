# Tools profile: a grab-bag of GUI + CLI utilities that don't fit any
# narrower bucket — calculators, password manager, screen recorders,
# CLI helpers, virt-manager, etc. Always-on by default.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.tools;
in {
  options.genoc.profile.tools = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      appimage-run          # one-shot AppImage runner with desktop integration
      bash                  # plain Bash (interactive variant lives in console-tools)
      bc                    # arbitrary-precision calculator (CLI)
      beep                  # PC speaker beeper
      certbot               # ACME / Let's Encrypt client
      findutils             # find / locate / xargs
      gawk                  # GNU awk
      ghostscript           # PostScript / PDF interpreter
      gnome-tweaks          # extra GNOME settings (works under KDE for some toggles)
      htop                  # interactive process viewer
      jq                    # JSON CLI processor
      kdePackages.kcalc     # KDE calculator
      keepassxc             # KeePass-compatible password manager
      kooha                 # simple GTK screen recorder
      libnotify             # notify-send and the libnotify lib
      p7zip                 # 7-zip archiver
      parted                # partitioning CLI (partprobe lives here)
      patch                 # GNU patch
      peek                  # GIF screen recorder
      plocate               # mlocate replacement (faster, smaller db)
      sqlite                # sqlite3 CLI
      sqlitebrowser         # GUI for SQLite databases
      tmux                  # terminal multiplexer
      veracrypt             # full-disk / file container encryption
      virt-manager          # libvirt GUI (KVM/QEMU/Xen)
      wl-clipboard          # Wayland clipboard CLI (wl-copy / wl-paste)
      wxmaxima              # GUI for Maxima CAS
      xclip                 # X11 clipboard CLI
      xlockmore             # screen locker (X11)
      xorg.xmessage         # tiny X11 dialog tool
    ];
  };
}
