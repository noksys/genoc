# Coldcard hardware wallet udev rules (USB + hidraw) so the device is
# usable without 'plugdev' group dependency.
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.hardware.coldcard.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf config.genoc.hardware.coldcard.enable {
    services.udev.extraRules = ''
      # Match the device on the immediate node (SUBSYSTEM/ATTR) rather than
      # walking the parent chain (SUBSYSTEMS/ATTRS). MODE=0666 lets the
      # user open the device without 'plugdev' group dependency.
      SUBSYSTEM=="usb", ATTR{idVendor}=="d13e", ATTR{idProduct}=="cc10", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", MODE="0666"
    '';

    environment.systemPackages = with pkgs; [
      libusb1   # USB access library
      udev      # device manager utilities
    ];
  };
}
