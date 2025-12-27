{ config, pkgs, lib, ... }:

let
  vars = import ../../../../custom_vars.nix;
  hledgerPort = 7501;
  publicPort  = 8351;
in {
  services.nginx = {
    enable = true;
    recommendedGzipSettings  = true;
    recommendedProxySettings = true;

    virtualHosts."hledger.local" = {
      listen = [{ addr = "127.0.0.1"; port = publicPort; }];
      default = true;
      serverAliases = [ "localhost" "127.0.0.1" ];

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString hledgerPort}";
        extraConfig = ''
          auth_basic "Restricted Area";
          auth_basic_user_file /etc/hledger/.htpasswd;

          proxy_redirect http://127.0.0.1:${toString hledgerPort}/ $scheme://$http_host/;
          proxy_redirect http://127.0.0.1/ $scheme://$http_host/;
          proxy_redirect http://localhost:${toString hledgerPort}/ $scheme://$http_host/;
          proxy_redirect http://localhost/ $scheme://$http_host/;
        '';
      };

      locations."=/favicon.ico" = {
        # alias = "/var/www/my-site/favicon.ico";
        extraConfig = ''
          access_log off;
          expires 30d;
          return 204; # No content
        '';
      };
    };
  };
  environment.etc."hledger/.htpasswd".text = vars.paisaAuth;
}
