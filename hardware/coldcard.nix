{ config, lib, pkgs, ... }:

{
  services.udev.extraRules = ''
    # Coldcard rules — match the device on the immediate node (SUBSYSTEM/ATTR)
    # rather than walking the parent chain (SUBSYSTEMS/ATTRS). MODE=0666 lets
    # the user open the device without 'plugdev' group dependency.
    SUBSYSTEM=="usb", ATTR{idVendor}=="d13e", ATTR{idProduct}=="cc10", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", MODE="0666"
  '';

  environment.systemPackages = with pkgs; [
    libusb1   # USB access library (CLI tools and pyusb backend)
    udev      # device manager utilities
  ];
}
