{ config, lib, pkgs, ... }:

let
  vars = import ../../custom_vars.nix;
  user = vars.mainUser;
  home = vars.homeDirectory;

  refreshScript = ../bin/refresh-smart.sh;
in
{
  # Regra udev que APENAS dispara o serviço systemd
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="refresh-smart-ac.service"
  '';

  # Serviço que roda quando o udev dispara
  systemd.user.services.refresh-smart-ac = {
    description = "Refresh screen rate on power change";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${refreshScript}";
      Environment = "PATH=${pkgs.xorg.xrandr}/bin:${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:${pkgs.bash}/bin";
    };
  };

  # Serviço que roda no login (mantido)
  systemd.user.services.refresh-smart-startup = {
    description = "Refresh screen rate on login";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${refreshScript}";
    };
  };
}
