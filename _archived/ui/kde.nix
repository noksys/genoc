{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
  user = vars.mainUser;
  home = vars.homeDirectory;
in
{
  # Display server / sessions
  services.xserver = {
    enable = true; # TMP
    displayManager = {
      lightdm.enable = lib.mkForce false;
    };

    # LXQt stays under xserver.*
    desktopManager = {
      lxqt.enable = lib.mkForce false;
    };
  };

  # Display managers (newer option path for gdm)
  services.displayManager = {
    gdm.enable = lib.mkForce false;

    sddm.enable = lib.mkDefault true;
    sddm.wayland.enable = lib.mkForce false;

    defaultSession = "plasmax11";
  };

  # Desktop managers (newer option path for gnome; Plasma 6 stays here)
  services.desktopManager = {
    gnome.enable = lib.mkForce false;
    plasma6.enable = lib.mkForce true;
  };

  # Misc services
  services.accounts-daemon.enable = true;
  # services.gnome.gnome-keyring.enable = true;
  # services.xserver.xautolock.enable = true;

  # Networking
  networking = {
    networkmanager = {
      enable = lib.mkDefault true;
      wifi.backend = lib.mkForce "iwd";
    };
    wireless.iwd.enable = lib.mkForce true;
  };

  # Disable Baloo indexer (systemd user unit)
  systemd.user.services.baloo_file = {
    wantedBy = [ ];
    enable = false;
  };

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "kde" ];
      };
    };
  };

  # Economic mode
  specialisation = {
    powersave.configuration = {
      environment.etc."xdg/baloofilerc".text = ''
        [Basic Settings]
        Indexing-Enabled=false
      '';

      systemd.user.services.baloo-disable = {
        description = "Disable KDE Baloo indexer";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "baloo-disable.sh" ''
            ${pkgs.kdePackages.baloo}/bin/balooctl6 disable || true
            ${pkgs.kdePackages.baloo}/bin/balooctl6 suspend || true
          '';
        };
      };

      services.geoclue2.enable = lib.mkForce false;
    };
  };

  # Audio / Wayland utilities
  services.pipewire.enable = true;
  programs.xwayland.enable = true;

  # Fix Qt
  environment.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = lib.mkForce "1";
    QT_QPA_PLATFORMTHEME = "kde";
  };

  systemd.user.services.set-qt-vars = {
    description = "Set Qt environment variables";
    wantedBy = [ "graphical-session.target" ];
    before = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "set-qt-vars.sh" ''
        systemctl --user set-environment QT_AUTO_SCREEN_SCALE_FACTOR=1
        systemctl --user set-environment QT_QPA_PLATFORMTHEME=kde
      '';
    };
  };

  # User packages
  users.users.${vars.mainUser} = lib.mkMerge [{
    packages = with pkgs; [
      colord

      kdePackages.dolphin
      kdePackages.gwenview
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
      kdePackages.kio-admin

      # Qt6 (explicit, since you were using qt6.full before)
      qt6.qtimageformats
      qt6.qtmultimedia
      qt6.qttools
      qt6.qtbase
      qt6.qtsvg
      qt6.qtwayland
      qt6.qtdeclarative
      qt6.qtshadertools

      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-wlr

      xorg.xinput
      xorg.xwininfo
      xorg.xdpyinfo
    ];
  }];
}
