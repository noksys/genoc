{ pkgs, lib, ... }:
{
  imports = [
    ../../hardware/video/base.nix
  ];

  # Enable the X11 windowing system (required as a base for SDDM even in Wayland)
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  # Ensure Wayland support is active for SDDM
  services.displayManager.sddm.wayland.enable = true;
  
  # Fix Qt scaling and theme
  environment.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORMTHEME = "kde";
  };
  
  # Portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    config.common.default = [ "kde" ];
  };
}