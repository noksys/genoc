{ pkgs }:

with pkgs; [
  brave              # privacy-leaning chromium fork
  chromium
  cjdns
  curl
  dbus
  docker
  epiphany           # GNOME Web (WebKitGTK)
  firefox
  google-chrome
  gpgme
  i2pd
  input-leap
  iw
  kdePackages.falkon # KDE web browser (Qt WebEngine)
  kdePackages.krdc
  librewolf          # privacy-focused Firefox fork
  megasync
  mosh
  mullvad-browser
  ncdu
  netbird-ui
  networkmanagerapplet
  nftables
  openssl
  #opera
  palemoon-bin
  #postman
  qutebrowser        # keyboard-driven Qt browser
  rclone
  signal-cli
  signal-desktop
  speedtest-cli
  syncthing
  telegram-desktop
  tor
  tor-browser
  torsocks
  wget
  wireguard-tools
  yubikey-agent
  yubioath-flutter
  yubikey-personalization
  vivaldi
  protonvpn-gui
]
