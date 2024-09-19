{ config, lib, pkgs, modulesPath, ... }:

{
  services.tor.relay.onionServices = {
    elements = {
      version = 3;
      map = [{
        port = 7041;
        target = { addr = "127.0.0.1"; port = 7041; };
      }];
    };
  };
}
