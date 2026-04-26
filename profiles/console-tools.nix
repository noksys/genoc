# Console-tools profile: the CLI essentials every interactive shell
# session expects (terminals, coreutils-full, archivers, network
# diagnostics, system monitoring, vim/neovim/spell, Nix tooling).
# Always-on by default; turn off only on truly headless setups that
# don't need the full toolbelt.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.console-tools;
in {
  options.genoc.profile.console-tools = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # ── Terminals (GPU + emergency fallback) ─────────────────────────────
      kitty                      # GPU-accelerated terminal
      wezterm                    # GPU-accelerated terminal (Lua-configured)
      xterm                      # bare-bones X11 terminal (emergency fallback)

      # ── Shells ───────────────────────────────────────────────────────────
      bashInteractive            # full Bash 5 with readline
      zsh                        # Z shell

      # ── coreutils / file utils ───────────────────────────────────────────
      coreutils-full             # GNU coreutils
      busybox                    # minimal coreutils-like emergency toolkit
      ccze                       # ANSI-colorize log streams
      pv                         # pipe viewer (progress for shell pipelines)
      ripgrep                    # fast recursive grep (rg)
      service-wrapper            # generic systemctl wrapper
      util-linux                 # mount / lsblk / setpriv / etc.
      psmisc                     # killall / pstree / fuser

      # ── Editors + spell ──────────────────────────────────────────────────
      vim                        # original Vi IMproved
      neovim                     # Vim fork, modern plugin runtime
      featherpad                 # lightweight Qt text editor
      aspell aspellDicts.en aspellDicts.pt_BR
      hunspell                   # libreoffice/firefox spell checker backend
      ispell                     # legacy spell checker

      # ── Archivers / compression ──────────────────────────────────────────
      bzip2 gzip lzip rzip szip unzip zip zlib

      # ── Filesystem tooling ───────────────────────────────────────────────
      btrfs-progs compsize       # btrfs userspace + stats
      ntfs3g                     # FUSE NTFS r/w
      gptfdisk                   # gdisk / sgdisk
      gparted                    # GUI partition editor
      efibootmgr                 # manage UEFI boot entries
      encfs                      # FUSE-based encrypted filesystem
      testdisk testdisk-qt       # partition / file recovery
      sysfsutils                 # /sys helpers

      # ── Network diagnostics ──────────────────────────────────────────────
      bind                       # dig / nslookup
      ethtool                    # NIC driver/PHY config
      iftop                      # network traffic monitor
      iotop                      # disk I/O monitor
      mtr                        # traceroute + ping fusion
      nmap                       # network scanner
      tcpdump tcpflow            # packet capture / per-flow recorder
      openssl                    # TLS / crypto CLI
      rclone                     # rsync for cloud storage
      rsync                      # delta-transfer file sync

      # ── System monitoring ────────────────────────────────────────────────
      btop                       # modern resource monitor
      cpupower-gui               # GUI / runtime tuning for CPU frequency scaling
      linuxPackages.cpupower     # follows running kernel
      inxi                       # quick hardware/software summary
      lsof                       # list open files

      # ── Build / inspection helpers ───────────────────────────────────────
      binutils                   # ld / as / objdump / nm
      boost                      # Boost C++ libraries
      pkg-config

      # ── Nix tooling ──────────────────────────────────────────────────────
      cachix                     # binary cache CLI
      home-manager               # per-user dotfiles manager
      nix-index                  # locate-style db for nix-locate
      nixos-option               # query NixOS option values from CLI

      # ── Misc ─────────────────────────────────────────────────────────────
      ddgr                       # DuckDuckGo terminal client
      elinks                     # ncurses web browser
      electron                   # Electron runtime (some pinned apps need a system one)
      parallel-full              # GNU parallel
      recoll                     # full-text desktop search
      tarsnap                    # encrypted offsite backup CLI
      usbutils                   # lsusb / usb-devices
      yad                        # GUI prompts in shell scripts

      # ── ZFS userspace ────────────────────────────────────────────────────
      zfs

      # ── X / keyboard / Xorg helpers ──────────────────────────────────────
      xkeyboard_config           # XKB data files (also via XKB_CONFIG_ROOT)
      xorg.xrdb                  # X resource database loader
    ];
  };
}
