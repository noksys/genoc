{ pkgs, lib, ... }:

{
  # Disable Baloo indexer (systemd user unit)
  # Baloo can be resource intensive.
  systemd.user.services.baloo_file = {
    wantedBy = [ ];
    enable = false;
  };

  # Aggressive optimization (useful for battery or low-end hardware)
  specialisation = {
    powersave.configuration = {
      environment.etc."xdg/baloofilerc".text = ''
        [Basic Settings]
        Indexing-Enabled=false
      '';

      systemd.user.services.baloo-disable = {
        description = "Disable KDE Baloo indexer";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "baloo-disable.sh" ''
            ${pkgs.kdePackages.baloo}/bin/balooctl6 disable || true
            ${pkgs.kdePackages.baloo}/bin/balooctl6 suspend || true
          '';
        };
      };

      services.geoclue2.enable = lib.mkForce false;
    };
  };
}
