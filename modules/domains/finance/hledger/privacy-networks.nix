{ config, pkgs, lib, ... }:

{
  services.i2pd = {
    enable = true;
    inTunnels = {
      hledger-site = {
        enable = true;
        keys = "hledger_site.dat";
        address = "127.0.0.1";
        port = 8351;
        inPort = 80;
      };
    };
  };

  services.tor = {
    relay.onionServices.hledger = {
      version = 3;
      path = "/var/lib/tor/onion/hledger";
      map = [{
        port = 80;
        target = {
          addr = "127.0.0.1";
          port = 8351;
        };
      }];
    };
  };
}
