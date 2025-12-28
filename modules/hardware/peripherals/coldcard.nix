{ config, lib, pkgs, ... }:

{
  services.udev.extraRules = ''
    # Coldcard rules
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="plugdev", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="plugdev", MODE="0666"
  '';

  environment.systemPackages = with pkgs; [
    libusb1 # USB access library/tools
    udev    # Device manager tools
  ];
}
