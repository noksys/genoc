# Disable hibernate + hybrid-sleep targets (machine has no swap big
# enough to hibernate to, or you simply don't want it).
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.hardware.noHibernation.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf config.genoc.hardware.noHibernation.enable {
    systemd.targets.hibernate = {
      enable = false;
      unitConfig.DefaultDependencies = "no";
    };
    systemd.targets."hybrid-sleep" = {
      enable = false;
      unitConfig.DefaultDependencies = "no";
    };
  };
}
