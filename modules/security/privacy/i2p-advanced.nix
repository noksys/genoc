{ pkgs, ... }: { 
  services.i2pd = {
    enable = true;
    proto.sam.enable = true; # Enable SAM bridge for application integration
    proto.http.enable = true; # Enable I2P HTTP proxy
    proto.httpProxy.enable = true;
  };
}
