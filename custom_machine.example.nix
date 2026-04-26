# Example custom_machine.nix for a new genoc-based machine.
# Copy/adapt this file to <yourmachine>/custom_machine.nix and trim.
#
# Almost everything is now an option under `genoc.<area>` or
# `genoc.profile.<name>`; the `imports` list is just the always-on
# infrastructure plus the machine-type module.
{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ./custom_vars.nix;
in
{
  imports = [
    # Hardware base — pick exactly one:
    ./genoc/hardware/vmware.nix                       # VM (qemu/vmware)
    # ./genoc/hardware/baremetal.nix                  # generic baremetal
    # ./genoc/hardware/lenovo-legion-pro7-16irx9h.nix # Legion Pro 7 Gen9 (NVIDIA + audio patch)

    # Always-on hardware modules (each is gated by genoc.hardware.<x>.enable;
    # listing them here registers their options; defaults are sensible).
    ./genoc/hardware/zfs.nix
    ./genoc/hardware/yubikey.nix
    ./genoc/hardware/coldcard.nix
    ./genoc/hardware/openrgb.nix
    ./genoc/hardware/backlight.nix
    ./genoc/hardware/color-calibration.nix
    ./genoc/hardware/bluetooth.nix
    ./genoc/hardware/no_hibernation.nix
    # ./genoc/hardware/no_sleep.nix                   # default off
    # ./genoc/hardware/wireless-ac1300.nix            # default off

    # Always-on infrastructure modules
    ./genoc/boot                                      # genoc.boot.{loader,plymouth}
    ./genoc/ui                                        # genoc.ui.{desktop,fonts,kmscon,…}
    ./genoc/security/tpm2.nix
    ./genoc/security/sddm-u2f.nix
    ./genoc/battery/tlp.nix
    ./genoc/battery/refresh-smart.nix

    # Profile module options (genoc.profile.<name>.enable)
    ./genoc/profiles
  ];

  # ── Boot ───────────────────────────────────────────────────────────────────
  genoc.boot.loader = "grub-efi-dualboot";   # or "grub-bios" | "systemd-boot"
  genoc.boot.plymouth.enable = true;

  # ── Audio + locale + UI ────────────────────────────────────────────────────
  genoc.audio  = "pipewire";                 # or "pulseaudio" | "none"
  genoc.locale = "ptbr";
  genoc.ui = {
    desktop                = "kde";          # or "gnome" | "lxqt" | "none"
    fonts.enable           = true;
    kmscon.enable          = true;
    consoleEditors.enable  = true;
  };

  # ── Backup ─────────────────────────────────────────────────────────────────
  # genoc.backup.tarsnap.enable = true;      # off by default; opt in if you use tarsnap

  # ── Profiles: opt-in workloads ─────────────────────────────────────────────
  genoc.profile.dev = {
    enable = true;
    # Per-language toolchain depth. Recognized: go js java python ruby
    # rust scheme lua perl cpp haskell prolog. Absent = off.
    langs = {
      go      = "full";
      python  = "full";
      rust    = "full";
      cpp     = "full";
      js      = "min";
      java    = "min";
      ruby    = "min";
      # haskell = "min";
      # prolog  = "full";
      # scheme  = "full";
    };
    # Cross-cutting workflow buckets. Recognized: cloud data containers
    # editors-gui planning ai. Absent = off.
    tasks = {
      cloud       = "full";
      data        = "full";
      containers  = "full";
      editors-gui = "full";
      planning    = "min";
      # ai        = "min";    # claude-code/codex/gemini-cli; "full" adds llama-cpp/lmstudio
    };
  };

  genoc.profile.gaming.enable = true;        # Steam, gamemode, mangohud, wine

  genoc.profile.crypto-node = {
    enable = true;
    coins = {
      btc      = "node";                     # "wallet" or "node"
      liquid   = "node";
      xmr      = "wallet";
      namecoin = "node";
    };
    wallets    = "full";                     # "min" = HW-wallet UIs; "full" = +Sparrow/Wasabi
    btcVariant = "knots";                    # alternative: "core" (vanilla Bitcoin Core)
  };

  genoc.profile.privacy.enable     = true;
  genoc.profile.education.enable   = true;
  genoc.profile.office = {
    enable     = true;
    accounting = "full";
    docs       = "full";
    suite      = "full";
  };
  genoc.profile.media-creator = {
    enable = true;
    mode   = "full";
  };

  genoc.profile.self-host = {
    enable = true;
    # Per-site toggles. Each site brings nginx vhost + i2p inTunnel + Tor onion.
    # sites.puma.enable        = true;
    # sites.paisa.enable       = true;
    # sites.hledger-web.enable = true;
  };

  # ── Always-on bundle profiles (defaults true; explicit for visibility) ─────
  genoc.profile.console-tools.enable  = true;
  genoc.profile.tools.enable          = true;
  genoc.profile.comm.enable           = true;
  genoc.profile.browsers.enable       = true;
  genoc.profile.network.enable        = true;
  genoc.profile.media-consumer.enable = true;
  genoc.profile.security-tools.enable = true;
  genoc.profile.fun.enable            = true;

  # ── Machine identity ───────────────────────────────────────────────────────
  networking.hostId = "DEADBEEF";            # 8-hex-char ZFS hostid; unique per machine
  # services.tor.settings = {
  #   Nickname    = "MyRelay";
  #   ContactInfo = "you@example.com";
  # };

  # ── Filesystems / LUKS ─────────────────────────────────────────────────────
  # fileSystems."/home" = {
  #   device = lib.mkForce "zpool/home";
  #   fsType = lib.mkForce "zfs";
  # };
  # boot.initrd.luks.devices = {
  #   "home" = { device = "/dev/disk/by-uuid/…"; preLVM = true; allowDiscards = true; };
  # };

  # ── Cron Jobs ──────────────────────────────────────────────────────────────
  # services.cron = {
  #   enable = true;
  #   systemCronJobs = [
  #     "0 16,20 * * * root ${vars.homeDirectory}/make-backup.sh > ${vars.homeDirectory}/last-backup.log 2>&1"
  #   ];
  # };
}
