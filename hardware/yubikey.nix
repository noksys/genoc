{ config, lib, pkgs, modulesPath, ... }:

{
  # Udev for Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      yubikey-agent
      yubikey-manager-qt
      yubikey-personalization
    ])
  ];
}
