{ config, lib, ... }:

let
  hasNvidia = lib.elem "nvidia" (config.services.xserver.videoDrivers or []);
in
{
  # PERFORMANCE MODE: dGPU is always ON and Primary.
  
  config = lib.mkIf hasNvidia {
    hardware.nvidia = {
      prime.offload.enable = lib.mkForce false;
      prime.sync.enable = lib.mkForce true;      # Force dGPU to drive the display
      powerManagement.enable = lib.mkForce false; # Disable RTD3
    };

    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __NV_PRIME_RENDER_OFFLOAD = "0";
    };
    
    # Udev rule to force power ON
    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", \
        RUN+="/bin/sh -c 'if [ -e /sys/bus/pci/devices/0000:01:00.0/power/control ]; then echo on > /sys/bus/pci/devices/0000:01:00.0/power/control; fi'"
    '';
  };
}
