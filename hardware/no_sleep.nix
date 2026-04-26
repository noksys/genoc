# Disable suspend / sleep targets and tell logind/upower to ignore
# the lid switch — for desktops, kiosks, or laptops that should never
# sleep regardless of lid or idle time.
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.hardware.noSleep.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Disable sleep/suspend targets and lid-switch sleep behavior.";
  };

  config = mkIf config.genoc.hardware.noSleep.enable {
    systemd.targets.sleep = {
      enable = false;
      unitConfig.DefaultDependencies = "no";
    };
    systemd.targets.suspend = {
      enable = false;
      unitConfig.DefaultDependencies = "no";
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
  };
}
