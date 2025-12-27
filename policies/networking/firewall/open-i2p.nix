{ ... }:
{
  # Open ports for I2P (I2PD)
  networking.firewall = {
    allowedTCPPorts = [ 45678 ];
    allowedUDPPorts = [ 45678 ];
  };
}
