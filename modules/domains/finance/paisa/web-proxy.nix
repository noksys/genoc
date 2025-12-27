{ config, pkgs, lib, ... }:

let
  vars = import ../../../../custom_vars.nix;
  paisaPort = 7500;
  publicPort  = 8350;
in {
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts."paisa.local" = {
      listen = [{ addr = "127.0.0.1"; port = publicPort; }];
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString paisaPort}";
        extraConfig = ''
          auth_basic "Restricted Area";
          auth_basic_user_file /etc/paisa/.htpasswd;
        '';
      };
    };
  };
  environment.etc."paisa/.htpasswd".text = vars.paisaAuth;
}
