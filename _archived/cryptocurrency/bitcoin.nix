{ config, lib, pkgs, modulesPath, ... }:

{
  services.tor.relay.onionServices = {
    bitcoin = {
      version = 3;
      map = [{
        port = 8333;
        target = { addr = "127.0.0.1"; port = 8333; };
      }];
    };
  };
}
