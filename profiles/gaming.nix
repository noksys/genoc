# Gaming profile: Steam + gamemode (automatic performance profile during games).
#
# Steam pulls in 32-bit graphics libs and quite a few dependencies, so guard
# the whole stack behind `enable` to keep it out of profiles that don't want
# games (e.g. a future server build).
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.gaming;
in {
  options.genoc.profile.gaming = {
    enable = mkEnableOption "gaming profile (Steam, gamemode)";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;     # Steam Remote Play (Link)
      dedicatedServer.openFirewall = true;
    };

    programs.gamemode.enable = true;
  };
}
