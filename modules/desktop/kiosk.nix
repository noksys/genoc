{ pkgs, ... }:

{
  # Minimal X server config for kiosk
  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true; # Example: Kodi as kiosk
  # Or use a browser in kiosk mode via systemd service (simplified here)
}
