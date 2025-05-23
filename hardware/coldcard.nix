{ config, lib, pkgs, ... }:

# See also ../cryptocurrency/electrum.nix

{
  services.udev.extraRules = ''
    # probably not needed:
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="plugdev", MODE="0666"

    # required:
    # from <https://github.com/signal11/hidapi/blob/master/udev/99-hid.rules>
    KERNEL=="hidraw*", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="plugdev", MODE="0666"
  '';

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      libusb1
      python311Packages.ckcc-protocol
      python3Full
      udev
    ])
  ];
}
