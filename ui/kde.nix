{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
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

  # áudio/wayland utilidades
  services.pipewire.enable = true;
  programs.xwayland.enable = true;

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
