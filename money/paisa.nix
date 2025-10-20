{ config, pkgs, lib, ... }:

let
  user       = "felipelalli";
  home       = "/home/${user}";
  paisaFlake = builtins.getFlake "github:ananthakumaran/paisa";
  paisaPkg   = paisaFlake.packages.${pkgs.system}.default;
  vars       = import ../../custom_vars.nix;
in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Handy in shell; hledger is required by Paisa when ledger_cli = hledger
  environment.systemPackages = [ paisaPkg pkgs.hledger ];

  # Paisa as a system service (simple, no cache hacks)
  systemd.services.paisa = {
    description = "Paisa Web Interface (system service)";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "network.target" ];

    # Put hledger on PATH for this unit
    path = [ pkgs.hledger ];

    serviceConfig = {
      User = user;
      Group = "users";
      WorkingDirectory = "${home}/Documents/paisa";
      ExecStart = "${paisaPkg}/bin/paisa serve";
      Restart = "on-failure";
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
