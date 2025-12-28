{ config, lib, pkgs, modulesPath, ... }:

{
  # Udev for Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.systemPackages = with pkgs; [
    yubikey-agent          # SSH agent using YubiKey
    yubioath-flutter       # OATH management tool
    yubikey-personalization # YubiKey personalization tools
  ];
}
