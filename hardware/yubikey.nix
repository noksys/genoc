# YubiKey support: udev rules + agent + OATH (TOTP/HOTP) management UI
# + provisioning CLI.
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.hardware.yubikey.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf config.genoc.hardware.yubikey.enable {
    services.udev.packages = [ pkgs.yubikey-personalization ];

    environment.systemPackages = with pkgs; [
      yubikey-agent
      yubioath-flutter
      yubikey-personalization
    ];
  };
}
