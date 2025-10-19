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
    displayManager.defaultSession = "plasmax11";

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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "kde" ];
      };
    };
  };

  # Make sure you have these services enabled
  services.pipewire.enable = true;
  programs.xwayland.enable = true;

  services.accounts-daemon.enable = true;

  users.users.${vars.mainUser} = lib.mkMerge [{
    packages = with pkgs; [
      colord
      dolphin
      gwenview
      kdePackages.baloo
      kdePackages.kaccounts-integration
      kdePackages.kaccounts-providers
      kdePackages.kate
      kdePackages.kconfig
      kdePackages.kdbusaddons
      kdePackages.kde-cli-tools
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kdepim-addons
      kdePackages.kdialog
      kdePackages.kimageformats
      kdePackages.kio-gdrive
      kdePackages.kservice
      kdePackages.plasma-workspace
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
      xorg.xdpyinfo
      libsForQt5.kdbusaddons
    ];
  }];
}
