# Tarsnap encrypted offsite backup. Disabled by default; flip
# `genoc.backup.tarsnap.enable = true;` in the machine config to opt in.
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.backup.tarsnap.enable =
    mkEnableOption "tarsnap encrypted offsite backup tooling";

  config = mkIf config.genoc.backup.tarsnap.enable {
    users.groups.tarsnap = {};
  };
}
