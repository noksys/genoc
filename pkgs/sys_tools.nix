{ pkgs }:

with pkgs; [
  alacritty                  # GPU-accelerated terminal
  bashInteractive            # full Bash 5 with readline (richer than the minimal `bash`)
  bind                       # dig / nslookup / DNS tooling
  binutils                   # ld / as / objdump / nm
  boost                      # Boost C++ libraries
  btop                       # modern resource monitor (htop's prettier cousin)
  btrfs-progs                # btrfs userspace
  busybox                    # minimal coreutils-like emergency toolkit
  bzip2                      # bz2 compressor
  ccze                       # ANSI-colorize log streams
  compsize                   # btrfs compression statistics
  coreutils-full             # GNU coreutils (full = also `[`, `pinky`, etc.)
  ddgr                       # DuckDuckGo terminal client
  efibootmgr                 # manage UEFI boot entries
  electron                   # Electron runtime (some pinned apps need a system one)
  elinks                     # ncurses web browser
  encfs                      # FUSE-based encrypted filesystem
  ethtool                    # NIC driver/PHY config
  gparted                    # GUI partition editor
  gptfdisk                   # gdisk / sgdisk
  gzip                       # gz compressor
  iftop                      # network traffic monitor
  inxi                       # quick hardware/software summary
  iotop                      # disk I/O monitor
  kitty                      # GPU-accelerated terminal (alternative to alacritty)
  linuxPackages.cpupower     # follows running kernel (6.12 LTS pinned in lenovo-legion)
  lsof                       # list open files / sockets
  lzip                       # lzip compressor
  mtr                        # network path diagnostics (traceroute + ping fusion)
  nmap                       # network scanner
  ntfs3g                     # FUSE NTFS r/w
  openssl                    # TLS / crypto CLI
  parallel-full              # GNU parallel (full edition with docs)
  pkg-config                 # build-time dependency lookup helper
  psmisc                     # killall / pstree / fuser
  ptyxis                     # GTK terminal (formerly GNOME Console)
  pv                         # pipe viewer (progress for shell pipelines)
  rclone                     # rsync for cloud storage
  recoll                     # full-text desktop search (Xapian-based)
  ripgrep                    # fast recursive grep (rg)
  rsync                      # delta-transfer file sync
  rzip                       # rzip compressor
  service-wrapper            # generic systemctl wrapper
  sysfsutils                 # /sys helpers
  szip                       # SZIP compressor (used by HDF5 etc.)
  tarsnap                    # encrypted offsite backup CLI
  tcpdump                    # packet capture
  tcpflow                    # TCP flow recorder (per-connection files)
  testdisk                   # partition / file recovery
  testdisk-qt                # Qt frontend for testdisk
  unzip                      # zip extractor
  usbutils                   # lsusb / usb-devices
  util-linux                 # mount / lsblk / setpriv / etc.
  wezterm                    # GPU-accelerated terminal (Lua-configured)
  xkeyboard_config           # XKB data files (also exported via XKB_CONFIG_ROOT)
  xorg.xrdb                  # X resource database loader
  xterm                      # bare-bones X11 terminal (emergency fallback)
  yad                        # Yet Another Dialog (GUI prompts in shell scripts)
  zfs                        # ZFS userspace
  zip                        # zip archiver
  zlib                       # zlib lib (included for completeness)
  zsh                        # Z shell
]
