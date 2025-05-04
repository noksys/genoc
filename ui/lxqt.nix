{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
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
      };

      # Desktop Manager configuration
      desktopManager = {
        gnome.enable = lib.mkForce false; # GNOME disabled
        lxqt.enable = lib.mkForce true;   # LXQt enabled
      };

      # Screen Lock
      xautolock = {
        enable = true;
        time = 8;
        locker = "${pkgs.betterlockscreen}/bin/betterlockscreen -l";
      };
    };

    # Display Manager without xserver prefix (SDDM)
    displayManager.sddm.enable = lib.mkForce false; # SDDM disabled

    # Desktop Manager for Plasma (without xserver prefix)
    desktopManager.plasma6.enable = lib.mkForce false; # Plasma 6 disabled

    # GNOME Keyring
    gnome.gnome-keyring.enable = true; # GNOME keyring enabled
  };

  users.users.${vars.mainUser} = lib.mkMerge [{
    packages = with pkgs; [
		gtk3
		lxqt.lxqt-config
		lxqt.lxqt-session
		lxqt.lxqt-panel
		lxqt.pcmanfm-qt
		lxqt.lxqt-powermanagement
		lxqt.lxqt-notificationd
		lxqt.qterminal
		lxqt.lxqt-policykit
		lxqt.pavucontrol-qt
		lxqt.lximage-qt
		lxqt.obconf-qt
		lxqt.qps
		lxqt.screengrab
		gtk2
		noto-fonts
		fontconfig
		openbox
		xautolock
		betterlockscreen
    ];
  }];
}
