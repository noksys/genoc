{ pkgs, ... }:
{
  imports = [
    ../../../modules/hardware/video/base.nix
  ];

  # Enable the X11 windowing system (still needed for GDM implementation details)
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Exclude default packages if you want a cleaner install (optional)
  services.gnome.core-apps.enable = true;

  # Cursor themes (icon themes)
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    kdePackages.breeze-icons
    bibata-cursors
    capitaine-cursors
    yaru-theme
  ];

  # Cursor default (GNOME / Wayland-safe)
  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "32";
  };
}

