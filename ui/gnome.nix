{ config, lib, pkgs, modulesPath, ... }:

{
  # Enable nm-applet
  # programs.nm-applet.enable = false;

  # Enable Picom for X11 compositing
  # services.picom.enable = false;

  # X11 configuration
  services = {
    xserver = {
      enable = true;

      # Display Manager configuration
      displayManager = {
        lightdm.enable = lib.mkForce false; # LightDM disabled
        gdm.enable = lib.mkForce true;      # GDM enabled

        # Desktop Manager configuration
        desktopManager = {
          gnome.enable = lib.mkForce true;  # GNOME enabled
          lxqt.enable = lib.mkForce false;  # LXQt disabled
        };
      };
    };

    # Display Manager without xserver prefix
    displayManager.sddm.enable = lib.mkForce false; # SDDM disabled

    # Desktop Manager for Plasma (without xserver prefix)
    desktopManager.plasma6.enable = lib.mkForce false; # Plasma 6 disabled

    # GNOME Keyring
    gnome.gnome-keyring.enable = true; # GNOME keyring enabled

    # X11 Screen Lock
    # services.xserver.xautolock.enable = true;
  };

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      gnome.gnome-shell
      gnome.gnome-shell-extensions
      gnomeExtensions.dash-to-dock
      webkitgtk
    ])
  ];
}
