{ pkgs, ... }:
{
  imports = [
    ../../../modules/hardware/video/base.nix
  ];

  # Enable the X11 windowing system (still needed for GDM implementation details)
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # GNOME is Wayland-only by default in modern versions.
  # X11 sessions might require specific overrides or older versions.
  
  # Exclude default packages if you want a cleaner install (optional)
  services.gnome.core-utilities.enable = true; 
}
