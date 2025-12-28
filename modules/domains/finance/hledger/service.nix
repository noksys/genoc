{ config, pkgs, lib, ... }:

let
  vars        = import ../../../../../custom_vars.nix;
  user        = vars.mainUser;
  home        = vars.homeDirectory;
  workDir     = "${home}/wa/mica-ledger";
  hledgerPort = 7501;
in {
  imports = [ ./package.nix ];

  systemd.services.hledger-web = {
    description = "hledger Web Interface (system service)";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "network-online.target" ];
    wants       = [ "network-online.target" ];
    path = [ pkgs.hledger pkgs.hledger-web ];

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

    script = ''
      set -euo pipefail
      test -f ${workDir}/hledger.conf || { echo "Missing: ${workDir}/hledger.conf"; exit 1; }

      exec ${pkgs.hledger}/bin/hledger \
        web \
        --conf ${workDir}/hledger.conf \
        -- \
        --port ${toString hledgerPort} \
        --base-url / \
        --serve
    '';
  };
}
