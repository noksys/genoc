{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
  user = vars.mainUser;
  home = vars.homeDirectory;
in
{
  # services / X11 / Plasma
  services = {
    xserver = {
      enable = true; # TMP
      displayManager = {
        lightdm.enable = lib.mkForce false;
        gdm.enable = lib.mkForce false;
      };
      desktopManager = {
        gnome.enable = lib.mkForce false;
        lxqt.enable = lib.mkForce false;
      };
    };

    displayManager.sddm.enable = lib.mkForce true;
    displayManager.sddm.wayland.enable = lib.mkForce false; # TMP
    displayManager.defaultSession = "plasmax11";

    desktopManager.plasma6.enable = lib.mkForce true;

    accounts-daemon.enable = true;
    # gnome.gnome-keyring.enable = true;
    # xserver.xautolock.enable = true;
  };

  # rede
  networking = {
    networkmanager = {
      enable = lib.mkDefault true;
      wifi.backend = lib.mkForce "iwd";
    };
    wireless.iwd.enable = lib.mkForce true;
  };

  # desabilitar indexador Baloo
  systemd.user.services.baloo_file = {
    wantedBy = [ ];
    enable = false;
  };

  # xdg portal
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde  # <- era xdg-desktop-portal-kde
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
      # Disable Baloo file indexer via config file (saves CPU and I/O)
      environment.etc."xdg/baloofilerc".text = ''
        [Basic Settings]
        Indexing-Enabled=false
      '';

      # Stop Baloo if it's running
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

      # Disable geoclue (location services)
      services.geoclue2.enable = lib.mkForce false;
    };
  };

  # áudio/wayland utilidades
  services.pipewire.enable = true;
  programs.xwayland.enable = true;

  # fix qt
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

  # pacotes do usuário
  users.users.${vars.mainUser} = lib.mkMerge [{
    packages = with pkgs; [
      colord
      kdePackages.dolphin                  # <- era dolphin
      kdePackages.gwenview                 # <- era gwenview
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
      kdePackages.kio-admin               # <- era kio-admin
      # Qt5 (legado). Remova se não precisar:
      # libsForQt5.kde-cli-tools
      # libsForQt5.kdbusaddons

      qt6.full
      qt6.qtimageformats
      qt6.qtmultimedia
      qt6.qttools

      kdePackages.xdg-desktop-portal-kde  # <- era xdg-desktop-portal-kde
      xdg-desktop-portal-wlr

      xorg.xinput
      xorg.xwininfo
      xorg.xdpyinfo
    ];
  }];
}
