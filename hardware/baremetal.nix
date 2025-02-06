{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../../hardware-configuration.nix
    #../sound/pulseaudio.nix
    ../sound/pipewire.nix
    ./bluetooth.nix
  ];

  # Virtualization
  virtualisation.vmware.guest.enable = false;

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      acpid
      aha
      brightnessctl
      clinfo
      evtest
      fwupd
      glxinfo
      libusb1
      lm_sensors
      pciutils
      tlp
      udev
      vulkan-tools
      wayland-utils
      xorg.xrandr
    ])
  ];
}
