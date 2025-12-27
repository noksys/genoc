{ config, lib, pkgs, modulesPath, ... }:

{
  systemd = {
    targets = {
      sleep = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      suspend = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
    };
  };

  services.power-profiles-daemon.enable = false;

  services.upower.enable = true;
  services.upower.ignoreLid = true;

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    extraConfig = ''
      IdleAction=ignore
    '';
  };
}
