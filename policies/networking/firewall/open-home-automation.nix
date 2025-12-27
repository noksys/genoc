{ ... }: {
  # Open ports for Home Assistant (8123) and Zigbee2MQTT (8080)
  networking.firewall.allowedTCPPorts = [ 8123 8080 ];
}
