{ ... }: {
  # Open standard Web ports (80/443) for Nginx, Caddy, Apache, etc.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
