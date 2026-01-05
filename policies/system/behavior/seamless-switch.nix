{ config, lib, pkgs, ... }:

{
  # Prevent critical desktop services from restarting during 'nixos-rebuild switch'.
  # This avoids killing the graphical session and dropping the network connection.
  # Changes to these services will only apply on the next reboot.

  systemd.services.display-manager.restartIfChanged = false;
  systemd.services.NetworkManager.restartIfChanged = false;
  systemd.services.wpa_supplicant.restartIfChanged = false;
}
