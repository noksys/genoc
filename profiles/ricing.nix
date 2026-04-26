# Ricing profile: KDE eye-candy (latte, plasma applets, decorative themes).
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.ricing;
in {
  options.genoc.profile.ricing = {
    enable = mkEnableOption "ricing profile (KDE eye-candy)";
  };

  config = mkIf cfg.enable { };
}
