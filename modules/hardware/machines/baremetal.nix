{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    #../../hardware-configuration.nix
    #../audio/pulseaudio-legacy.nix
    ../audio/pipewire.nix
    ../peripherals/bluetooth.nix
  ];

  # Virtualization
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
