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
    acpid         # ACPI event daemon
    aha           # Hardware info (ahasyst)
    brightnessctl # Backlight control
    clinfo        # OpenCL info
    evtest        # Input device tester
    fwupd         # Firmware updates
    mesa-demos    # OpenGL demos
    libusb1       # USB access library/tools
    lm_sensors    # Hardware sensors
    pciutils      # PCI utilities
    tlp           # Power management
    udev          # Device manager tools
    vulkan-tools  # Vulkan tools
    wayland-utils # Wayland diagnostics
    xorg.xrandr   # X11 display config tool
  ];
}
