{ config, lib, pkgs, modulesPath, ... }:

{
  systemd = {
    targets = {
      hibernate = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      "hybrid-sleep" = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
    };
  };
}
