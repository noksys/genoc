{ config, pkgs, ... }:

let
  user      = "felipelalli";
  home      = "/home/${user}";
  paisaFlake = builtins.getFlake "github:ananthakumaran/paisa";
  paisaPkg   = paisaFlake.packages.${pkgs.system}.default;
  vars       = import ../../custom_vars.nix;
in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = [ paisaPkg pkgs.ledger ];

  # Ensure the cache path exists for the bind-mount destination
  systemd.tmpfiles.rules = [
    "d ${home}/.cache 0755 ${user} users -"
    "d ${home}/.cache/paisa 0755 ${user} users -"
    "f ${home}/.cache/paisa/ledger 0755 ${user} users -"
  ];

  # Paisa as a system service (so BindReadOnlyPaths works)
  systemd.services.paisa = {
    description = "Paisa Web Interface (system service)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      User = user;
      Group = "users";
      WorkingDirectory = "${home}/Documents/paisa";
      Environment = "XDG_CACHE_HOME=${home}/.cache";
      ExecStart = "${paisaPkg}/bin/paisa serve";
      Restart = "on-failure";

      # Force Paisa to use NixOS ledger (overrides ~/.cache/paisa/ledger)
      BindReadOnlyPaths = [
        "/run/current-system/sw/bin/ledger:${home}/.cache/paisa/ledger"
      ];
    };
  };

  # Nginx reverse proxy (localhost:8350) + Basic Auth
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts."paisa.local" = {
      listen = [{ addr = "127.0.0.1"; port = 8350; }];
      locations."/" = {
        proxyPass = "http://127.0.0.1:7500";
        extraConfig = ''
          auth_basic "Restricted Area";
          auth_basic_user_file /etc/paisa/.htpasswd;
        '';
      };
    };
  };

  # htpasswd line comes from your vars
  environment.etc."paisa/.htpasswd".text = vars.paisaAuth;

  # I2P inbound tunnel (ye2k.i2p -> localhost:8350)
  services.i2pd = {
    enable = true;
    inTunnels = {
      paisa-site = {
        enable = true;
        keys = "paisa_site.dat";
        address = "127.0.0.1";
        destination = "127.0.0.1";
        port = 8350;   # upstream (nginx)
        inPort = 80;   # I2P-side HTTP port
      };
    };
  };
}
