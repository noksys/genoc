{ config, lib, pkgs, modulesPath, ... }:

{
  # Enable nm-applet
  programs.nm-applet.enable = true;

  # Enable Picom for X11 compositing
  services.picom.enable = true;

  # X11 configuration
  services = {
    xserver = {
      enable = true;

      # Display Manager configuration
      displayManager = {
        lightdm.enable = lib.mkForce true;  # LightDM enabled
        gdm.enable = lib.mkForce false;     # GDM disabled

        # Desktop Manager configuration
        desktopManager = {
          gnome.enable = lib.mkForce false; # GNOME disabled
          lxqt.enable = lib.mkForce true;   # LXQt enabled
        };
      };

      # X11 Screen Lock
      xautolock.enable = true; # Enable X11 screen lock
    };

    # Display Manager without xserver prefix (SDDM)
    displayManager.sddm.enable = lib.mkForce false; # SDDM disabled

    # Desktop Manager for Plasma (without xserver prefix)
    desktopManager.plasma6.enable = lib.mkForce false; # Plasma 6 disabled

    # GNOME Keyring
    gnome.gnome-keyring.enable = true; # GNOME keyring enabled
  };
}
