# Bare-metal hardware essentials. Active when genoc.hardware.machine is
# "baremetal" or "lenovo-legion-pro7-16irx9h" (lenovo extends baremetal).
{ config, lib, pkgs, ... }:

lib.mkIf (config.genoc.hardware.machine == "baremetal"
       || config.genoc.hardware.machine == "lenovo-legion-pro7-16irx9h") {
  virtualisation.vmware.guest.enable = false;

  environment.systemPackages = with pkgs; [
    acpid
    aha
    brightnessctl
    clinfo
    evtest
    fwupd
    mesa-demos
    libusb1
    lm_sensors
    pciutils
    tlp
    udev
    vulkan-tools
    wayland-utils
    xorg.xrandr
  ];
}
