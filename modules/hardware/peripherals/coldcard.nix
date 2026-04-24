{ config, lib, pkgs, ... }:

{
  services.udev.extraRules = ''
    # Coldcard rules
    SUBSYSTEM=="usb", ATTR{idVendor}=="d13e", ATTR{idProduct}=="cc10", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", MODE="0666"
  '';

  environment.systemPackages = with pkgs; [
    libusb1 # USB access library/tools
    udev    # Device manager tools
  ];
}
