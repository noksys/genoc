{ config, lib, pkgs, modulesPath, ... }:

lib.mkIf (config.genoc.ui.desktop == "gnome") {
  # X11 base (ainda necessário para alguns componentes; no GNOME 49 a sessão X11 não existe mais,
  # mas manter services.xserver.enable não costuma atrapalhar e pode ser útil para bits legacy.)
  services.xserver.enable = true;

  # Display managers — gdm and sddm have new-path options; lightdm
  # stayed under services.xserver.displayManager and we leave its
  # default (off) untouched.
  services.displayManager = {
    gdm.enable  = lib.mkDefault true;       # ↓ mkDefault so the "text"
                                            # specialisation can mkForce false
    sddm.enable = lib.mkForce false;
  };

  # Desktop managers (novo path; lxqt does not have a new-path option,
  # it stays under services.xserver.desktopManager.lxqt — leave alone).
  services.desktopManager = {
    gnome.enable = lib.mkForce true;
    plasma6.enable = lib.mkForce false;
  };

  # GNOME Keyring (path ok)
  services.gnome.gnome-keyring.enable = true;

  # Pacotes extras (paths atualizados para nixpkgs 25.11)
  environment.systemPackages = with pkgs; [
    gnome-shell
    gnome-shell-extensions
    gnomeExtensions.dash-to-dock
    webkitgtk_4_1
  ];
}
