# Lenovo Legion Pro 7 16IRX9H (Gen 9, NVIDIA RTX 4090 Laptop, ALC287 audio).
# Active when genoc.hardware.machine = "lenovo-legion-pro7-16irx9h".
#
# Note: the per-machine nixos-hardware module (<nixos-hardware/lenovo/
# legion/16irx9h>) is imported from custom_machine.nix, NOT here —
# imports can't be gated by config so we'd be force-loading Legion
# kernel hints on every other machine that pulls genoc.
#
# baremetal.nix's mkIf condition includes "lenovo-..." too, so picking
# this machine activates the baremetal essentials as well.
{ config, lib, pkgs, ... }:

lib.mkIf (config.genoc.hardware.machine == "lenovo-legion-pro7-16irx9h") {
  # Pin to LTS 6.12 — NVIDIA proprietary drivers (580.x) fail to build on 6.19+
  # (struct vm_area_struct dropped __vm_flags in 6.19).
  # lib.mkForce overrides zfs.nix dynamic selection (6.12 is ZFS-compatible).
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

  # ---- Audio: impedir desync ALC287 <-> TAS2781 smart-amps ------------------
  # Alto-falantes = 2x TI TAS2781 (i2c TIAS2781:00) escravos do Realtek ALC287
  # (subsystem 0x17aa38cd). Quando snd_hda_intel faz runtime power-save do
  # codec, o link do tas2781-hda quebra e os alto-falantes emudecem apos pouco
  # tempo ocioso; fone P2/BT (que nao passam pelo smart-amp) continuam.
  # Fix: nunca power-save no codec HDA.
  #
  # NB: o antigo legion-alc287.patch mirava o subsystem 0x17aa3863, que NAO
  # bate com esta unidade (0x17aa38cd) -> nunca foi aplicado. Removido.
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  # Prevent the AVS driver from grabbing the device (keep using snd-hda-intel).
  boot.blacklistedKernelModules = [ "snd_soc_avs" ];

  # ---- Audio: re-sync do TAS2781 apos suspend/resume (S3) -------------------
  # Ao voltar do suspend, o link HDA <-> amp pode cair (mesmo estado "mudo" que
  # o power_save derrubava por ociosidade). Um unbind/bind do device i2c
  # re-anexa o componente tas2781-hda ao ALC287 -> recuperacao comprovada na
  # mao. Idempotente; custa um glitch <1s no resume. power_save/control ja sao
  # persistentes (modprobe + udev acima); aqui so reforcamos o control e o bind.
  powerManagement.resumeCommands = ''
    dev=i2c-TIAS2781:00
    echo on > /sys/bus/i2c/devices/$dev/power/control || true
    if [ -e /sys/bus/i2c/drivers/tas2781-hda/$dev ]; then
      echo "$dev" > /sys/bus/i2c/drivers/tas2781-hda/unbind || true
      ${pkgs.coreutils}/bin/sleep 1
      echo "$dev" > /sys/bus/i2c/drivers/tas2781-hda/bind || true
    fi
  '';

  # ---- USB autosuspend OFF (default profile) + crash capture -----------------
  # The xHCI/Thunderbolt bus destabilises under USB power management: devices
  # (notably the YubiKey) re-enumerate repeatedly and the box hard-freezes
  # (incident 2026-06-03 ~03:08; same signature 2026-05-05 / 2026-05-07).
  # Disable USB autosuspend in the default (AC/performance) profile so there is
  # no suspend/resume churn. The powersave specialisation deliberately KEEPS
  # autosuspend=1 for battery (see below). Also turn the next silent freeze
  # into a capturable panic.
  boot.kernelParams = [
    "usbcore.autosuspend=-1"   # default profile only: no USB autosuspend
  ];

  # pstore(efi_pstore) is already active, so a panic's dmesg survives the reboot
  # in /sys/fs/pstore. We deliberately do NOT auto-reboot (kernel.panic = 0) so
  # the panic stays on screen for a photo if it reaches the console.
  boot.kernel.sysctl = {
    "kernel.panic_on_oops"    = 1;   # an oops becomes a panic (gets recorded)
    "kernel.panic"            = 0;   # do NOT auto-reboot; leave the panic up
    "kernel.nmi_watchdog"     = 1;   # REQUIRED: without it hardlockup_panic never fires
    "kernel.hardlockup_panic" = 1;   # NMI-detected hard lockup -> panic
    # softlockup_panic / hung_task_panic left OFF on purpose: ZFS D-state stalls
    # (scrub / heavy IO) could false-trigger a reboot.
  };

  # ---- Graphics base (PERFORMANCE by default) -------------------------------
  # Base profile: run the whole desktop on the NVIDIA dGPU for max smoothness.
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open               = false;
    nvidiaSettings     = false;
    nvidiaPersistenced = false;

    # IMPORTANT: do NOT mkForce here; the powersave specialisation will override.
    prime.offload.enable   = false;  # dGPU drives the session (no offload)
    prime.sync.enable      = true;   # better smoothness if panel is iGPU-wired
    powerManagement.enable = false;  # do not try to RTD3 the dGPU in base
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
    # KWIN_FORCE_SW_CURSOR      = "1";
  };

  # ---- dGPU runtime power policy via udev (helps RTD3 when on battery) -----
  # Keep dGPU "on" when on AC and allow autosuspend (RTD3) when on battery.
  services.udev.extraRules = ''
    # TAS2781 smart-amp: nunca runtime-suspend (reforco do power_save=0 acima).
    ACTION=="add", SUBSYSTEM=="i2c", KERNEL=="*TIAS2781*", ATTR{power/control}="on"

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
  # so the kernel doesn't touch it at all. Trade-off: prime-run will not work
  # in this specialisation; CUDA / Steam GPU games / Blender GPU render fail
  # until you reboot back to the default.
  specialisation.powersave.configuration = {
    services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];

    # Keep genoc's powersave autosuspend=1 here (battery saving is the point of
    # this profile). The default profile sets autosuspend=-1, which this
    # specialisation inherits; re-assert =1 LAST (mkAfter) so it deterministically
    # wins on the kernel cmdline regardless of merge order. Also re-enable the NMI
    # watchdog that genoc disables (nmi_watchdog=0) so a powersave-mode freeze is
    # still caught by hardlockup_panic. Negligible battery cost.
    boot.kernelParams = lib.mkAfter [ "usbcore.autosuspend=1" ];
    boot.kernel.sysctl."kernel.nmi_watchdog" = lib.mkForce 1;

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

    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = lib.mkForce "mesa";
      __NV_PRIME_RENDER_OFFLOAD = lib.mkForce "";
      GBM_BACKEND               = lib.mkForce "";
    };
  };
}
