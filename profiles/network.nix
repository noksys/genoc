# Network profile: networking CLI tools, mesh/P2P clients, KVM/remote
# desktop, VPN GUIs. (Browsers live in profile.browsers; messengers in
# profile.comm; the daemons themselves — Tor relay, i2pd, NetBird —
# come from privacy/configuration.)
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.network;
in {
  options.genoc.profile.network = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cjdns                # mesh routing protocol daemon
      dbus                 # IPC daemon CLI tools
      gpgme                # GnuPG made easy library + CLI
      input-leap           # software KVM (Barrier fork)
      iw                   # nl80211 wireless config CLI
      kdePackages.krdc     # KDE remote desktop client (RDP/VNC/SSH)
      mosh                 # mobile shell (resilient SSH replacement)
      ncdu                 # ncurses disk usage analyzer
      netbird-ui           # NetBird mesh VPN UI
      networkmanagerapplet # nm-applet (system tray client)
      nftables             # netfilter / nft CLI
      protonvpn-gui        # Proton VPN GUI client
      speedtest-cli        # Ookla speedtest CLI
      syncthing            # P2P file sync daemon
      torsocks             # transparent SOCKS over Tor
      wget                 # HTTP/FTP downloader
      wireguard-tools      # wg / wg-quick CLI
      megasync             # MEGA cloud sync client
    ];
  };
}
