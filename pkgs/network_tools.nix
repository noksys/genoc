{ pkgs }:

with pkgs; [
  brave                          # privacy-leaning Chromium fork
  chromium                       # vanilla Chromium
  cjdns                          # mesh routing protocol daemon
  curl                           # HTTP/HTTPS/FTP transfer tool
  dbus                           # IPC daemon CLI tools
  docker                         # Docker engine CLI (daemon enabled in dev/docker.nix)
  firefox                        # Mozilla Firefox
  google-chrome                  # Google Chrome
  gpgme                          # GnuPG made easy library + CLI
  i2pd                           # I2P daemon (C++ implementation)
  input-leap                     # software KVM (Barrier fork)
  iw                             # nl80211 wireless config CLI
  kdePackages.falkon             # KDE web browser (Qt WebEngine)
  kdePackages.krdc               # KDE remote desktop client (RDP/VNC/SSH)
  librewolf                      # privacy-focused Firefox fork
  megasync                       # MEGA cloud sync client
  mosh                           # mobile shell (resilient SSH replacement)
  mullvad-browser                # Mullvad's hardened Firefox build
  ncdu                           # ncurses disk usage analyzer
  netbird-ui                     # NetBird mesh VPN UI (paired with services.netbird)
  networkmanagerapplet           # nm-applet (system tray client)
  nftables                       # netfilter / nft CLI
  openssl                        # TLS / crypto CLI
  #opera                         # commented (Opera deprecated for our use)
  #postman                       # commented (use Apidog AppImage instead)
  protonvpn-gui                  # Proton VPN GUI client
  qutebrowser                    # keyboard-driven Qt browser
  rclone                         # rsync for cloud storage
  signal-cli                     # Signal Messenger CLI
  signal-desktop                 # Signal Messenger desktop
  speedtest-cli                  # Ookla speedtest CLI
  syncthing                      # P2P file sync daemon (service in common.nix)
  telegram-desktop               # Telegram official Qt client
  tor                            # The Onion Router daemon
  tor-browser                    # Tor Browser bundle
  torsocks                       # transparent SOCKS over Tor
  vivaldi                        # Vivaldi browser
  wget                           # HTTP/FTP downloader
  wireguard-tools                # wg / wg-quick CLI
  yubikey-agent                  # SSH agent backed by YubiKey
  yubikey-personalization        # YubiKey provisioning tool
  yubioath-flutter               # OATH (TOTP/HOTP) management for YubiKey
]
