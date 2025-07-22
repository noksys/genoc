{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  # Enable nm-applet
  #programs.nm-applet.enable = true;

  # Enable Picom for X11 compositing
  #services.picom.enable = true;

  # X11 configuration
  services = {
    xserver = {
      enable = true; # TMP

      # Display Manager configuration
      displayManager = {
        lightdm.enable = lib.mkForce false;
        gdm.enable = lib.mkForce false;
      };

      # Desktop Manager configuration
      desktopManager = {
        gnome.enable = lib.mkForce false;
        lxqt.enable = lib.mkForce false;
      };
    };

    # Display Manager without xserver prefix
    displayManager.sddm.enable = lib.mkForce true;
    displayManager.sddm.wayland.enable = lib.mkForce false; # TMP

    # Desktop Manager for Plasma (without xserver prefix)
    desktopManager.plasma6.enable = lib.mkForce true;

    # GNOME Keyring
    # gnome.gnome-keyring.enable = true;

    # X11 Screen Lock
    # services.xserver.xautolock.enable = true;
  };

  # Fix WiFi
  networking = {
    networkmanager = {
      enable = lib.mkDefault true;
      wifi.backend = lib.mkForce "iwd";
    };
    wireless.iwd.enable = lib.mkForce true;
  };

  # Disable file index
  systemd.user.services.baloo_file = {
    wantedBy = [ ];
    enable = false;
  };

  users.users.${vars.mainUser} = lib.mkMerge [{
    packages = with pkgs; [
      dolphin
      gwenview
      kdePackages.baloo
      kdePackages.kate
      kdePackages.kconfig
      kdePackages.kdbusaddons
      kdePackages.kde-cli-tools
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kdialog
      kdePackages.kimageformats
      kdePackages.kservice
      kdePackages.systemsettings
      kio-admin
      libsForQt5.kde-cli-tools
      qt6.full
      qt6.qtimageformats
      qt6.qtmultimedia
      qt6.qttools
      xdg-desktop-portal-kde
      xdg-desktop-portal-wlr
      xorg.xinput
      xorg.xwininfo
      colord
    ];
  }];
}
