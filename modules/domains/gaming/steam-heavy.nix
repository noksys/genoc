{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud            # Vulkan/OpenGL overlay for FPS and metrics
    protonup-qt         # Proton/GE manager for Steam
    lutris              # Game launcher for multiple sources
    heroic              # Epic Games / GOG launcher
    wineWowPackages.stable # 32-bit/64-bit Wine
    winetricks          # Wine helper scripts
  ];
}
