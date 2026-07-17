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

  # ---- Audio: keep ALC287 <-> TAS2781 smart-amps from desyncing -------------
  # Internal speakers are 2x TI TAS2781 smart-amps (i2c TIAS2781:00) slaved to
  # the Realtek ALC287 (subsystem 0x17aa38cd). When snd_hda_intel runtime
  # power-saves the codec, the tas2781-hda component link drops and the
  # speakers go silent after a short idle; headphones (jack/BT, which bypass
  # the smart-amp) keep working. Fix: never power-save the HDA codec.
  #
  # NB: the old legion-alc287.patch targeted subsystem 0x17aa3863, which never
  # matched this unit (0x17aa38cd), so it was never applied. Dropped.
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  # Prevent the AVS driver from grabbing the device (keep using snd-hda-intel).
  boot.blacklistedKernelModules = [ "snd_soc_avs" ];

  # ---- Audio: re-sync the TAS2781 after suspend/resume (S3) ------------------
  # Across a suspend the HDA <-> amp link can drop (same "silent" state that
  # power_save caused on idle). Unbinding/binding the i2c device re-attaches
  # the tas2781-hda component to the ALC287 -> proven manual recovery.
  # Idempotent; costs a <1s glitch on resume. power_save/control are already
  # persistent (modprobe + udev above); here we only re-assert control + bind.
  powerManagement.resumeCommands = ''
    dev=i2c-TIAS2781:00
    echo on > /sys/bus/i2c/devices/$dev/power/control || true
    if [ -e /sys/bus/i2c/drivers/tas2781-hda/$dev ]; then
      echo "$dev" > /sys/bus/i2c/drivers/tas2781-hda/unbind || true
      ${pkgs.coreutils}/bin/sleep 1
      echo "$dev" > /sys/bus/i2c/drivers/tas2781-hda/bind || true
    fi
  '';

  # ---- Audio: stop TLP from re-enabling the HDA codec power-save ------------
  # TLP (services.tlp) defaults SOUND_POWER_SAVE_ON_{AC,BAT}=1, so it writes
  # power_save=1 to snd_hda_intel at startup and on every AC<->battery switch,
  # overriding BOTH boot.extraModprobeConfig and the snd_hda_intel.power_save=0
  # kernel cmdline param below. That is what kept re-triggering the TAS2781
  # desync after boot. Force it off (settings merge with battery/tlp.nix).
  services.tlp.settings = {
    SOUND_POWER_SAVE_ON_AC = "0";
    SOUND_POWER_SAVE_ON_BAT = "0";
  };

  # ---- Audio: guaranteed re-sync ~30s after the desktop is up ---------------
  # Belt-and-suspenders for the same desync: even with power_save pinned off,
  # the codec<->amp link can come up desynced at boot (speakers silent until a
  # rebind). One unbind/bind of the i2c device re-attaches the tas2781-hda
  # component to the ALC287 -- the proven manual recovery, durable for the
  # whole session. Run it once shortly after graphical.target, when the audio
  # stack (and TLP) have settled.
  systemd.services.tas2781-resync = {
    description = "Re-sync TAS2781 smart-amp after boot (restore laptop speakers)";
    wantedBy = [ "graphical.target" ];
    after = [ "graphical.target" "sound.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 30";
      ExecStart = pkgs.writeShellScript "tas2781-resync" ''
        dev=i2c-TIAS2781:00
        echo 0  > /sys/module/snd_hda_intel/parameters/power_save || true
        echo on > /sys/bus/pci/devices/0000:00:1f.3/power/control || true
        echo on > /sys/bus/i2c/devices/$dev/power/control || true
        if [ -e /sys/bus/i2c/drivers/tas2781-hda/$dev ]; then
          echo "$dev" > /sys/bus/i2c/drivers/tas2781-hda/unbind || true
          ${pkgs.coreutils}/bin/sleep 1
          echo "$dev" > /sys/bus/i2c/drivers/tas2781-hda/bind || true
        fi
      '';
    };
  };

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
    # Force the HDA codec's power_save OFF at module init. The modprobe.d
    # option (boot.extraModprobeConfig above) does NOT stick: snd_hda_intel is
    # coldplugged in the initrd, which ignores /etc/modprobe.d, so the module
    # comes up with the kernel default (1) and the real-root config is never
    # reapplied. A kernel cmdline param applies regardless of how/when the
    # module loads. Without this the codec power-saves on idle and the TAS2781
    # smart-amp desyncs (speakers go silent shortly after login).
    "snd_hda_intel.power_save=0"
    # Disable Intel Panel Self Refresh. The internal panel (eDP-1) is wired to
    # the i915 (card1) and does the scanout even when the desktop renders on the
    # NVIDIA dGPU (PRIME sync). PSR exit on screensaver/DPMS wake hangs the
    # display engine: black screen + frozen session while the kernel stays alive
    # (audio kept playing). Logged signature: i915 "Atomic update failure on
    # pipe A" (recurring). Incident 2026-06-30; see ai-play-ground/2026-06-30_freeze.md.
    "i915.enable_psr=0"
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

  # ---- Hardware error monitoring (RAS) --------------------------------------
  # Log + decode Machine Check Exceptions and memory (EDAC) errors. Passive,
  # event-driven daemon: ~0 CPU at idle, no per-instruction checking (the CPU's
  # Machine Check Architecture is always on in HW regardless). Added 2026-07-01
  # after corrected MCEs (Bank 0) + cross-program segfaults showed up; we want
  # every future MCE decoded with a timestamp to tell hardware marginality apart
  # from the GPU/Wayland freezes. Query: `ras-mc-ctl --errors` / `--summary`.
  hardware.rasdaemon.enable = true;

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
    #
    # 2026-06-30: ENABLED. Recurrent hard freezes on GPU events (screensaver
    # wake; launching an Electron app) with KWin spewing "Failed to create an
    # offscreen framebuffer" / glTexStorage2D before the display dies. See
    # ai-play-ground/2026-06-30_freeze.md. Mitigation on the nvidia-Wayland path.
    KWIN_FORCE_SW_CURSOR      = "1";
  };

  # ---- dGPU runtime power policy via udev (helps RTD3 when on battery) -----
  # Keep dGPU "on" when on AC and allow autosuspend (RTD3) when on battery.
  services.udev.extraRules = ''
    # TAS2781 smart-amp: never runtime-suspend (reinforces power_save=0 above).
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
