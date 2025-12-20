# lenovo.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    <nixos-hardware/lenovo/legion/16irx8h>
    ./baremetal.nix
  ];

  # ---- Audio firmware patch -------------------------------------------------
  # Ship a tiny custom firmware patch for the ALC287 codec.
  hardware.firmware = [
    (pkgs.runCommand "legion-audio-patch" {} ''
      mkdir -p $out/lib/firmware
      cp ${./legion-alc287.patch} $out/lib/firmware/legion-alc287.patch
    '')
  ];

  # Apply the patch at module load time.
  boot.extraModprobeConfig = ''
    # options snd-hda-intel model=alc287-yoga9-bass-spk-pin
    options snd-hda-intel patch=legion-alc287.patch
  '';

  # Prevent the AVS driver from grabbing the device (keep using snd-hda-intel).
  boot.blacklistedKernelModules = [ "snd_soc_avs" ];

  # ---- Graphics base (PERFORMANCE by default) -------------------------------
  # Base profile: run the whole desktop on the NVIDIA dGPU for max smoothness.
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # PRIME plumbing and proprietary driver for the 4090 Laptop GPU.
    modesetting.enable = true;
    open               = false;
    nvidiaSettings     = false;
    nvidiaPersistenced = false;

    # IMPORTANT: do NOT mkForce here; the powersave specialisation will override.
    # Base = performance: dGPU is primary (no RTD3).
    prime.offload.enable   = false;  # dGPU drives the session (no offload)
    prime.sync.enable      = true;   # better smoothness if panel is iGPU-wired
    powerManagement.enable = false;  # do not try to RTD3 the dGPU in base
    # finegrained has no effect without offload
  };

  # These env vars "pin" the base session to the NVIDIA stack for X11/GBM.
  # The powersave specialisation will override these to Mesa/empty.
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __NV_PRIME_RENDER_OFFLOAD = "0";
    GBM_BACKEND               = "nvidia-drm";
    MOZ_DISABLE_RDD_SANDBOX   = "1";
  };

  # ---- dGPU runtime power policy via udev (helps RTD3 when on battery) -----
  # Keep dGPU "on" when on AC and allow autosuspend (RTD3) when on battery.
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", \
      RUN+="/bin/sh -c 'echo on > /sys/bus/pci/devices/0000:01:00.0/power/control'"

    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", \
      RUN+="/bin/sh -c 'echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control'"
  '';

  # ---- NVIDIA / userland tools ---------------------------------------------
  environment.systemPackages = with pkgs; [
    nvtopPackages.intel
    nv-codec-headers
    nvidia-container-toolkit
    nvidia-optical-flow-sdk
    nvidia-system-monitor-qt
    nvidia-texture-tools
    nvidia-vaapi-driver
    nvtopPackages.nvidia
  ];

  # ---- Specialisation: POWERSAVE (iGPU primary + NVIDIA RTD3) ---------------
  # Goal: run desktop on Intel iGPU; only wake the dGPU on explicit demand
  # via prime-run, and allow it to autosuspend when idle.
  specialisation = {
    powersave.configuration = {
      hardware.nvidia = {
        # Here we DO mkForce to ensure we override the base profile cleanly.
        prime.offload.enable        = lib.mkForce true;   # iGPU drives; use `prime-run <cmd>` for dGPU
        prime.sync.enable           = lib.mkForce false;  # sync is mutually exclusive with offload
        powerManagement.enable      = lib.mkForce true;   # enable RTD3 (runtime suspend)
        powerManagement.finegrained = lib.mkForce true;   # only valid with offload
      };

      # Crucial: stop "pinning" the session to NVIDIA on powersave.
      # We do NOT clear the whole attribute set (so NIX_PATH etc. remain intact);
      # we only override the keys that force NVIDIA.
      environment.sessionVariables = {
        __GLX_VENDOR_LIBRARY_NAME = lib.mkForce "mesa";  # pick Mesa GLX vendor
        __NV_PRIME_RENDER_OFFLOAD = lib.mkForce "";      # unset -> no forced offload
        GBM_BACKEND               = lib.mkForce "";      # let GBM pick defaults
        # Keep all other session variables inherited from the base system.
      };
    };
  };
}
