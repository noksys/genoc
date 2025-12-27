{ config, pkgs, lib, ... }:

let
  publicPort  = 8350;
in {
  services.i2pd = {
    enable = true;
    inTunnels = {
      paisa-site = {
        enable = true;
        keys = "paisa_site.dat";
        address = "127.0.0.1";
        destination = "127.0.0.1";
        port = publicPort;
        inPort = 80;
      };
    };
  };

  services.tor = {
    relay.onionServices.paisa = {
      version = 3;
      path = "/var/lib/tor/onion/paisa";
      map = [{
        port = 80;
        target = {
          addr = "127.0.0.1";
          port = publicPort;
        };
      }];
    };
  };
}
