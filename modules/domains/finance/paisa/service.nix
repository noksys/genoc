{ config, pkgs, lib, ... }:

let
  vars = import ../../../../../custom_vars.nix;
  user = vars.mainUser;
  home = vars.homeDirectory;
in {
  imports = [ ./package.nix ];

  systemd.services.paisa = {
    description = "Paisa Web Interface (system service)";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "network.target" ];
    path = [ pkgs.hledger ];

    serviceConfig = {
      User = user;
      Group = "users";
      WorkingDirectory = "${home}/Documents/paisa";
      Restart = "on-failure";
      ExecStart = "${pkgs.paisa}/bin/paisa serve";
    };
  };
}
