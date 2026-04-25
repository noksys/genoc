{ pkgs }:

with pkgs; [
  alacritty
  bashInteractive
  bind          # dig / nslookup / DNS tooling
  binutils
  boost
  btop
  btrfs-progs
  busybox
  bzip2
  ccze
  compsize
  coreutils-full
  ddgr          # DuckDuckGo terminal client
  efibootmgr
  electron
  elinks
  encfs
  ethtool
  gparted
  gptfdisk
  gzip
  iftop         # network traffic monitor
  inxi
  iotop
  kitty
  linuxKernel.packages.linux_6_6.cpupower
  lsof
  lzip
  mtr           # network path diagnostics
  nmap
  ntfs3g
  openssl
  parallel-full
  pkg-config
  psmisc        # provides killall
  ptyxis
  pv
  rclone
  recoll
  ripgrep
  rsync
  rzip
  service-wrapper
  sysfsutils
  szip
  tarsnap
  tcpdump
  tcpflow
  testdisk
  testdisk-qt
  tgpt          # ChatGPT-style CLI without API key
  unzip
  usbutils
  util-linux
  wezterm
  xkeyboard_config
  xorg.xrdb
  xterm
  yad
  zfs
  zip
  zlib
  zsh
]
