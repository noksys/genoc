# Gaming profile: Steam, gamemode, sway lock (used by some games' overlays).
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.gaming;
in {
  options.genoc.profile.gaming = {
    enable = mkEnableOption "gaming profile (Steam, gamemode)";
  };

  config = mkIf cfg.enable { };
}
