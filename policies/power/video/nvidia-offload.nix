{ config, lib, ... }:

let
  hasNvidia = lib.elem "nvidia" (config.services.xserver.videoDrivers or []);
in
{
  # ECO / OFFLOAD MODE: iGPU is Primary. dGPU sleeps (RTD3) until summoned.
  
  config = lib.mkIf hasNvidia {
    hardware.nvidia = {
      prime.offload.enable = lib.mkForce true;
      prime.sync.enable = lib.mkForce false;
      powerManagement.enable = lib.mkForce true;   # Enable RTD3
      powerManagement.finegrained = lib.mkForce true;
    };

    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = lib.mkForce "mesa";
      GBM_BACKEND = lib.mkForce ""; # Let it auto-detect (usually mesa/intel)
      __NV_PRIME_RENDER_OFFLOAD = lib.mkForce "";
    };
    
    # Udev rule to allow auto-suspend
    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", \
        RUN+="/bin/sh -c 'if [ -e /sys/bus/pci/devices/0000:01:00.0/power/control ]; then echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control; fi'"
    '';
  };
}
