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
    # SDDM as a Wayland greeter — picks up the monitor's native DPI and
    # renders the login screen at sane size on HiDPI panels. The user's
    # session can still be X11 via defaultSession below.
    sddm.wayland.enable = true;

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

      # Stop KDE side-services that idle but still wake the CPU periodically:
      # Akonadi (PIM backend — only needed if you read mail in KMail/Kontact)
      # KDE Connect daemon (phone integration). Re-enable manually if needed.
      # caffeine-ng (user enables it via home-manager — not relevant in powersave
      # since the whole point is to let the system idle/suspend).
      systemd.user.services.kde-extras-disable = {
        description = "Stop Akonadi + KDE Connect + caffeine-ng in powersave";
        wantedBy = [ "graphical-session.target" ];
        # Run AFTER caffeine.service so its main process exists when we
        # ask systemd-user to stop it (avoids the race where pkill fires
        # before caffeine has even started).
        after = [ "caffeine.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "kde-extras-disable.sh" ''
            ${pkgs.kdePackages.akonadi}/bin/akonadictl stop || true
            ${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-cli --refresh || true
            pkill -f kdeconnectd || true
            # systemctl stop tells the user manager NOT to restart caffeine;
            # the pkill is just belt-and-suspenders for any forked child.
            ${pkgs.systemd}/bin/systemctl --user stop caffeine.service 2>/dev/null || true
            pkill -f caffeine || true
          '';
        };
      };

      services.geoclue2.enable = lib.mkForce false;
    };
  };

  # Audio / Wayland utilities
  services.pipewire.enable = true;
  programs.xwayland.enable = true;

  # Use KDE's ksshaskpass for SSH passphrase prompts (instead of GNOME seahorse).
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  # Fix Qt. QT_AUTO_SCREEN_SCALE_FACTOR is intentionally left unset here so
  # the user's home-manager owns it (avoids a system-vs-home tug-of-war on
  # the Qt scaling knob).
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
    # Plasma 6 was auto-picking 48px on HiDPI; 32 is comfortable on the
    # Legion's panel without the giant 48px overshoot.
    XCURSOR_SIZE = "32";
  };

  systemd.user.services.set-qt-vars = {
    description = "Set Qt environment variables";
    wantedBy = [ "graphical-session.target" ];
    before = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "set-qt-vars.sh" ''
        systemctl --user set-environment QT_QPA_PLATFORMTHEME=kde
      '';
    };
  };

  # User packages
  users.users.${vars.mainUser} = lib.mkMerge [{
    packages = with pkgs; [
      colord
      kdePackages.colord-kde      # Plasma GUI for colord ICC profiles

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

      # apps-full additions from v2 dev-gui
      kdePackages.ark            # archive manager
      kdePackages.filelight      # disk usage visualizer
      kdePackages.kcolorchooser  # color picker
      kdePackages.kruler         # on-screen ruler
      kdePackages.spectacle      # screenshot tool

      xorg.xinput
      xorg.xwininfo
      xorg.xdpyinfo
    ];
  }];
}
