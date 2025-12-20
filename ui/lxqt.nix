{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  # nm-applet
  programs.nm-applet.enable = true;

  # Picom (X11)
  services.picom.enable = true;

  # X server
  services.xserver = {
    enable = true;

    # LXQt stays under xserver.*
    desktopManager.lxqt.enable = lib.mkForce true;

    # Screen lock (continua sob xserver)
    xautolock = {
      enable = true;
      time = 8;
      locker = "${pkgs.betterlockscreen}/bin/betterlockscreen -l";
    };
  };

  # Display managers (path novo)
  services.displayManager = {
    lightdm.enable = lib.mkForce true;
    gdm.enable = lib.mkForce false;
    sddm.enable = lib.mkForce false;
  };

  # Desktop managers (path novo: GNOME + Plasma6)
  services.desktopManager = {
    gnome.enable = lib.mkForce false;
    plasma6.enable = lib.mkForce false;
  };

  # GNOME Keyring (path ok)
  services.gnome.gnome-keyring.enable = true;

  # User packages
  users.users.${vars.mainUser} = lib.mkMerge [{
    packages = with pkgs; [
      gtk3
      gtk2
      noto-fonts
      fontconfig

      # LXQt
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

      # WM / X11 tools
      openbox
      xorg.xdpyinfo
      mesa-demos

      # lockscreen stack
      betterlockscreen
      xautolock
    ];
  }];
}
