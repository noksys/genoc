{ pkgs, lib, ... }:
{
  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.displayManager.sddm.enable = true; # Using SDDM as a good lightweight-ish DM
  
  environment.systemPackages = with pkgs; [
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-whiskermenu-plugin
  ];
}
