{ pkgs }:

with pkgs; [
  #terminator           # don't work well with KDE+Wayland
  #appimagekit          # legacy AppImage tooling — not needed alongside appimage-run
  #clickup              # ClickUp client — commented (not in current rotation)
  appimage-run          # one-shot AppImage runner with desktop integration
  bash                  # plain Bash (interactive variant lives in sys_tools)
  bc                    # arbitrary-precision calculator (CLI)
  beep                  # PC speaker beeper
  calibre               # ebook library / converter / reader
  certbot               # ACME / Let's Encrypt client
  findutils             # find / locate / xargs
  gawk                  # GNU awk
  ghostscript           # PostScript / PDF interpreter
  htop                  # interactive process viewer
  jq                    # JSON CLI processor
  kdePackages.kcalc     # KDE calculator
  keepassxc             # KeePass-compatible password manager
  kooha                 # simple GTK screen recorder
  libnotify             # notify-send and the libnotify lib
  mermaid-cli           # Mermaid diagram CLI renderer
  p7zip                 # 7-zip archiver
  parted                # partitioning CLI (partprobe lives here)
  patch                 # GNU patch
  peek                  # GIF screen recorder (kept by user choice)
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
]
