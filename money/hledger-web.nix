{ config, pkgs, lib, ... }:

let
  # Shared vars
  vars        = import ../../custom_vars.nix;

  # Effective user/home
  user        = vars.mainUser;
  home        = vars.homeDirectory;

  # Project directory (journal + hledger.conf)
  workDir     = "${home}/wa/mica-ledger";

  # Internal app port and public reverse-proxy port
  hledgerPort = 7501;
  publicPort  = 8351;
in {
  # Enable flakes/nix-command (Nix lists do not use commas)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optional convenience in shells
  environment.systemPackages = [ pkgs.hledger pkgs.hledger-web ];

  # hledger web as a systemd service (use `hledger web` so hledger.conf is honored)
  systemd.services.hledger-web = {
    description = "hledger Web Interface (system service)";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "network-online.target" ];
    wants       = [ "network-online.target" ];

    # Both hledger (wrapper) and hledger-web (addon) in PATH
    path = [ pkgs.hledger pkgs.hledger-web ];

    serviceConfig = {
      User = user;
      Group = "users";

      # Makes relative paths predictable and logs easier to find
      WorkingDirectory = workDir;

      Restart    = "on-failure";
      RestartSec = 3;

      # Minimal, explicit environment (hledger defaults rely on HOME)
      Environment = [
        "LANG=en_US.UTF-8"
        "HOME=${home}"  # so hledger finds ~/.hledger.journal by default
      ];

      StandardOutput = "journal";
      StandardError  = "journal";
    };

    # IMPORTANT: On older hledger (e.g., 1.40), addon flags must come AFTER `--`.
    # We call `hledger web` (not `hledger-web`) so the config file is honored.
    script = ''
      set -euo pipefail
      echo "PWD=$(pwd) HOME=$HOME"
      test -f ${workDir}/hledger.conf || { echo "Missing: ${workDir}/hledger.conf"; exit 1; }

      exec ${pkgs.hledger}/bin/hledger \
        web \
        --conf ${workDir}/hledger.conf \
        -- \
        --port ${toString hledgerPort} \
        --serve
      # NOTE: do NOT set --base-url here; Nginx will rewrite Location: headers.
    '';
  };

  # Nginx reverse proxy with Basic Auth and Location rewrite
  services.nginx = {
    enable = true;
    recommendedGzipSettings  = true;
    recommendedProxySettings = true;

    virtualHosts."hledger.local" = {
      # Bind only on loopback; change addr if you want LAN access
      listen = [{ addr = "127.0.0.1"; port = publicPort; }];

      # Make it catch-all for this port (good when hitting by IP/localhost)
      default = true;
      serverAliases = [ "localhost" "127.0.0.1" ];

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString hledgerPort}";
        # Real reverse proxy behavior:
        # - Keep upstream Host semantics (already handled by recommendedProxySettings),
        # - Rewrite absolute Location headers from the upstream to the incoming host.
        extraConfig = ''
          # Basic Auth
          auth_basic "Restricted Area";
          auth_basic_user_file /etc/hledger/.htpasswd;

          # Rewrite upstream absolute redirects to the actual requested host (incl. port if present).
          # $http_host preserves "host:port" from the client (e.g., 127.0.0.1:8351, localhost, or a .b32.i2p host).
          proxy_redirect http://127.0.0.1:${toString hledgerPort}/ $scheme://$http_host/;
          proxy_redirect http://127.0.0.1/ $scheme://$http_host/;

          # (optional) Slightly more tolerant timeouts if you browse heavy reports:
          # proxy_read_timeout 120s;
          # proxy_send_timeout 120s;
        '';
      };

      locations."=/favicon.ico" = {
        alias = "/var/www/elaine.i2p/favicon.ico";
        extraConfig = ''
          access_log off;
          expires 30d;
        '';
      };
    };
  };

  # Basic Auth credentials file (Apache htpasswd format)
  environment.etc."hledger/.htpasswd".text = vars.paisaAuth;

  # I2P inbound tunnel (exposes hledger.local through a .b32.i2p address)
  services.i2pd = {
    enable = true;

    inTunnels = {
      # new tunnel for hledger
      hledger-site = {
        enable = true;
        keys = "hledger_site.dat";   # key file name (stored under /var/lib/i2pd)
        address = "127.0.0.1";
        destination = "127.0.0.1";
        port = 8351;   # the nginx proxy for hledger
        inPort = 80;   # I2P-side HTTP port
      };
    };
  };

  # Tor
  services.tor = {
    relay.onionServices.hledger = {
      version = 3;
      path = "/var/lib/tor/hledger";
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
