{ ... }: {
  # Open default Syncthing ports (22000 TCP for data, 21027 UDP for discovery)
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 21027 22000 ];
}
