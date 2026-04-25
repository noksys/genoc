# lenovo.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    <nixos-hardware/lenovo/legion/16irx8h>
    ./baremetal.nix
  ];

  # Pin to LTS 6.12 — NVIDIA proprietary drivers (580.x) fail to build on 6.19+
  # (struct vm_area_struct dropped __vm_flags in 6.19).
  # lib.mkForce overrides zfs.nix dynamic selection (6.12 is ZFS-compatible).
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

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

    # Force KWin to draw the cursor in software (CPU compositing path) instead
    # of using the NVIDIA hardware cursor plane.
    #
    # Workaround for NVIDIA Bug 5983006: on hybrid (Intel iGPU + NVIDIA dGPU)
    # laptops the nvidia-drm-fb.c "non_scanout_mem_backed" path can hand KWin
    # a framebuffer with pSurface=NULL, which the driver then dereferences.
    # Symptoms: invisible/frozen cursor, KWin restart loop, occasional kernel
    # oops on Wayland — historically only triggered on this machine when running
    # dual-monitor; uncomment if it comes back on multi-display setups.
    #
    # Cost: a few ms of cursor latency, negligible CPU. Drop this line once
    # the NVIDIA proprietary driver ships a fix or the dGPU is no longer
    # session-primary on this machine.
    # KWIN_FORCE_SW_CURSOR      = "1";
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

  # ---- Specialisation: POWERSAVE (iGPU only, NVIDIA fully off) --------------
  # Goal: run desktop on Intel iGPU; the NVIDIA dGPU is COMPLETELY blacklisted
  # so the kernel doesn't touch it at all. This is the most aggressive battery
  # mode (~4-7W less than RTD3-offload). Trade-off: prime-run will not work in
  # this specialisation; CUDA / Steam GPU games / Blender GPU render fail until
  # you reboot back to the default. NVreg_DynamicPowerManagement is set as a
  # safety net for the case where the user later un-blacklists nvidia and
  # falls back to RTD3 D3cold without rebuilding the whole spec.
  specialisation = {
    powersave.configuration = {
      services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];

      boot.blacklistedKernelModules = [
        "nvidia" "nvidia_drm" "nvidia_uvm" "nvidia_modeset"
      ];

      boot.extraModprobeConfig = ''
        # Even when not blacklisted, force the deepest dynamic PM state (D3cold).
        options nvidia "NVreg_DynamicPowerManagement=0x02"
      '';

      hardware.nvidia = {
        prime.offload.enable           = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;
        prime.sync.enable              = lib.mkForce false;
        powerManagement.enable         = lib.mkForce false;
        powerManagement.finegrained    = lib.mkForce false;
      };

      # Stop "pinning" the session to NVIDIA on powersave.
      environment.sessionVariables = {
        __GLX_VENDOR_LIBRARY_NAME = lib.mkForce "mesa";
        __NV_PRIME_RENDER_OFFLOAD = lib.mkForce "";
        GBM_BACKEND               = lib.mkForce "";
      };
    };
  };
}
