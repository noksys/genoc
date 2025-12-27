{ config, lib, pkgs, modulesPath, ... }:

{
  # X11 base (ainda necessário para alguns componentes; no GNOME 49 a sessão X11 não existe mais,
  # mas manter services.xserver.enable não costuma atrapalhar e pode ser útil para bits legacy.)
  services.xserver.enable = true;

  # Display managers (novo path)
  services.displayManager = {
    lightdm.enable = lib.mkForce false;
    gdm.enable = lib.mkForce true;

    sddm.enable = lib.mkForce false;
  };

  # Desktop managers (novo path)
  services.desktopManager = {
    gnome.enable = lib.mkForce true;
    lxqt.enable = lib.mkForce false;
    plasma6.enable = lib.mkForce false;
  };

  # GNOME Keyring (path ok)
  services.gnome.gnome-keyring.enable = true;

  # Pacotes extras
  environment.systemPackages = with pkgs; [
    gnome.gnome-shell
    gnome.gnome-shell-extensions
    gnomeExtensions.dash-to-dock
    webkitgtk
  ];
}
