# Self-host profile: nginx in front of small local web apps, exposed
# over loopback + i2p inTunnels (.b32.i2p) + Tor v3 onion services.
#
#   genoc.profile.self-host.enable
#       Turns on nginx with the global rate-limit / log-format / error-page
#       config. No site is exposed by default.
#
#   genoc.profile.self-host.sites.<name>.enable
#       Per-site toggle. Each site brings: nginx vhost, i2pd inTunnel,
#       Tor onion service map (where applicable), and any backing
#       systemd unit (paisa, hledger-web).
#
#   genoc.profile.self-host.sites.puma.notifyService
#       Run the nginx-notify + nginx-banwatch user services that watch
#       the access log. Default true; set false if the user-side
#       scripts under ~/bin aren't installed yet.
#
# All authentication uses the same htpasswd content (vars.paisaAuth) —
# it's the original credential the user wired both apps with.
{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../custom_vars.nix;
  user = vars.mainUser;
  home = vars.homeDirectory;
  cfg  = config.genoc.profile.self-host;
in {
  options.genoc.profile.self-host = {
    enable = mkEnableOption "self-host nginx + i2p + Tor stack";

    sites.puma.enable        = mkEnableOption "puma static site (puma.i2p)";
    sites.puma.notifyService = mkOption {
      type = types.bool;
      default = true;
      description = "Run nginx-notify + nginx-banwatch user services watching the access log.";
    };

    sites.paisa.enable        = mkEnableOption "paisa accounting web UI";
    sites.hledger-web.enable  = mkEnableOption "hledger-web web UI";
  };

  config = mkIf cfg.enable (mkMerge [
    # ── Global nginx setup ───────────────────────────────────────────────────
    {
      services.nginx = {
        enable = true;
        recommendedGzipSettings  = true;
        recommendedProxySettings = true;

        # Top of the http{} block: log format + global rate/connection limits.
        commonHttpConfig = ''
          log_format puma_access
            '$time_iso8601 ip=$remote_addr host=$host:$server_port '
            'method=$request_method uri="$request_uri" status=$status '
            'bytes=$body_bytes_sent referer="$http_referer" '
            'ua="$http_user_agent" proto=$server_protocol rt=$request_time '
            'tls="$ssl_protocol $ssl_cipher" reqid=$request_id';

          map $request_method $rl_key { default "global"; }
          limit_req_zone $rl_key zone=global_rl:10m rate=5r/s;
          limit_req_status 429;
          limit_req zone=global_rl burst=100 nodelay;

          map $request_method $conn_key { default "global"; }
          limit_conn_zone $conn_key zone=global_conn:10m;
          limit_conn global_conn 200;

          error_page 400 401 403 404 500 502 503 504 /_error.html;
        '';

        # Bottom of the http{} block: global access log using the format above.
        appendHttpConfig = ''
          access_log /var/log/nginx/access.log puma_access;
        '';
      };

      # i2pd data lives on the user's parked dataset so keys survive reinstalls.
      fileSystems."/var/lib/i2pd" = {
        device  = "${home}/parked/auth/i2p";
        options = [ "bind" ];
      };

      environment.systemPackages = [ pkgs.nginx ];
    }

    # ── Site: puma (puma.i2p, static content) ────────────────────────────────
    (mkIf cfg.sites.puma.enable {
      fileSystems."/var/www/puma.i2p" = {
        device  = "${home}/www/puma.i2p";
        options = [ "bind" ];
      };

      services.nginx.virtualHosts."localhost" = {
        root      = "/var/www/puma.i2p";
        listen    = [{ addr = "127.0.0.1"; port = 591; }];
        locations."/" = {};
      };

      # i2p inTunnel for puma — historically commented in the source.
      # Uncomment to expose the static site over puma.i2p:
      # services.i2pd.inTunnels.http-site = {
      #   port = 591; destination = "127.0.0.1"; inPort = 80;
      #   keys = "http_site.dat";
      # };

      # Tor onion service for puma — historically commented in the source.
      # services.tor.relay.onionServices.puma = {
      #   version = 3;
      #   path = "/var/lib/tor/onion/puma";
      #   map = [{ port = 80; target = { addr = "127.0.0.1"; port = 591; }; }];
      # };
    })

    (mkIf (cfg.sites.puma.enable && cfg.sites.puma.notifyService) {
      # Notify on Nginx access log entries.
      systemd.user.services.nginx-notify = {
        description = "Notify on Nginx access log entries";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "%h/bin/nginx-notify.sh";
          Restart = "always";
          RestartSec = "10";
          StandardOutput = "journal";
          StandardError = "journal";
          Environment = "PATH=/run/current-system/sw/bin";
        };
      };

      # Ban server in case of repeated wrong-password attempts.
      systemd.user.services.nginx-banwatch = {
        description = "Ban after failed nginx auth attempts";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "%h/bin/nginx-banwatch.sh";
          Restart = "always";
          RestartSec = 3;
          Environment = "PATH=/run/current-system/sw/bin";
        };
      };
    })

    # ── Site: paisa (accounting web UI) ──────────────────────────────────────
    (mkIf cfg.sites.paisa.enable (
      let
        paisaFlake  = builtins.getFlake "github:ananthakumaran/paisa";
        paisaPkg    = paisaFlake.packages.${pkgs.system}.default;
        paisaPort   = 7500;
        publicPort  = 8350;
      in {
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        environment.systemPackages = [ paisaPkg pkgs.hledger ];

        systemd.services.paisa = {
          description = "Paisa Web Interface";
          wantedBy = [ "multi-user.target" ];
          after    = [ "network.target" ];
          path     = [ pkgs.hledger ];
          serviceConfig = {
            User = user;
            Group = "users";
            WorkingDirectory = "${home}/Documents/paisa";
            Restart = "on-failure";
            ExecStart = "${paisaPkg}/bin/paisa serve";
          };
        };

        services.nginx.virtualHosts."paisa.local" = {
          listen = [{ addr = "127.0.0.1"; port = publicPort; }];
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString paisaPort}";
            extraConfig = ''
              auth_basic "Restricted Area";
              auth_basic_user_file /etc/paisa/.htpasswd;
            '';
          };
        };
        environment.etc."paisa/.htpasswd".text = vars.paisaAuth;

        services.i2pd.inTunnels.paisa-site = {
          enable = true;
          keys = "paisa_site.dat";
          address = "127.0.0.1";
          destination = "127.0.0.1";
          port = publicPort;
          inPort = 80;
        };

        services.tor.relay.onionServices.paisa = {
          version = 3;
          path = "/var/lib/tor/onion/paisa";
          map = [{ port = 80; target = { addr = "127.0.0.1"; port = publicPort; }; }];
        };
      }
    ))

    # ── Site: hledger-web ────────────────────────────────────────────────────
    (mkIf cfg.sites.hledger-web.enable (
      let
        workDir     = "${home}/wa/mica-ledger";
        hledgerPort = 7501;
        publicPort  = 8351;
      in {
        environment.systemPackages = [ pkgs.hledger pkgs.hledger-web ];

        systemd.services.hledger-web = {
          description = "hledger Web Interface";
          wantedBy = [ "multi-user.target" ];
          after    = [ "network-online.target" ];
          wants    = [ "network-online.target" ];
          path     = [ pkgs.hledger pkgs.hledger-web ];
          serviceConfig = {
            User = user;
            Group = "users";
            WorkingDirectory = workDir;
            Restart    = "on-failure";
            RestartSec = 3;
            Environment = [
              "LANG=en_US.UTF-8"
              "HOME=${home}"
            ];
            StandardOutput = "journal";
            StandardError  = "journal";
          };
          # On older hledger (e.g., 1.40), addon flags must come AFTER `--`.
          # Calling `hledger web` (not `hledger-web`) so hledger.conf is honored.
          script = ''
            set -euo pipefail
            test -f ${workDir}/hledger.conf || { echo "Missing: ${workDir}/hledger.conf"; exit 1; }
            exec ${pkgs.hledger}/bin/hledger web --conf ${workDir}/hledger.conf -- \
              --port ${toString hledgerPort} --base-url / --serve
          '';
        };

        services.nginx.virtualHosts."hledger.local" = {
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
            alias = "/var/www/elaine.i2p/favicon.ico";
            extraConfig = ''
              access_log off;
              expires 30d;
            '';
          };
        };
        environment.etc."hledger/.htpasswd".text = vars.paisaAuth;

        services.i2pd.inTunnels.hledger-site = {
          enable = true;
          keys = "hledger_site.dat";
          address = "127.0.0.1";
          destination = "127.0.0.1";
          port = publicPort;
          inPort = 80;
        };

        services.tor.relay.onionServices.hledger = {
          version = 3;
          path = "/var/lib/tor/onion/hledger";
          map = [{ port = 80; target = { addr = "127.0.0.1"; port = publicPort; }; }];
        };
      }
    ))
  ]);
}
