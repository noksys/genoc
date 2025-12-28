{ pkgs, ... }:

{
  imports = [ ./steam-regular.nix ];

  environment.systemPackages = with pkgs; [
    lutris              # Game launcher for multiple sources
    heroic              # Epic Games / GOG launcher
    wineWowPackages.stable # 32-bit/64-bit Wine
    winetricks          # Wine helper scripts
  ];
}
