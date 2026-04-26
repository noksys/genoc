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

    # FPS / GPU overlay. The package ships its Vulkan implicit-layer
    # manifest under share/vulkan/implicit_layer.d/, which goes into
    # /run/current-system/sw and is rediscovered on every rebuild — so
    # we skip the home-manager xdg workaround that re-symlinked it.
    environment.systemPackages = [ pkgs.mangohud ];
  };
}
