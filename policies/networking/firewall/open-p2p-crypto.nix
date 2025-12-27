{ ... }: {
  # Open ports for Bitcoin (8333) and Elements (17041)
  networking.firewall.allowedTCPPorts = [ 8333 17041 ];
}
