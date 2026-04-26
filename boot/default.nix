# Boot stack: bootloader (GRUB BIOS, GRUB EFI dualboot, or systemd-boot)
# and Plymouth boot splash. All options live under genoc.boot so the
# machine config picks variants instead of swapping imports.
{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../custom_vars.nix;
  cfg  = config.genoc.boot;

  grubFont = pkgs.runCommand "grub-font-36" {} ''
    mkdir -p $out
    ${pkgs.grub2}/bin/grub-mkfont -s 36 -o $out/DejaVuSansMono36.pf2 \
      ${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf
  '';
in {
  options.genoc.boot = {
    loader = mkOption {
      type = types.enum [ "none" "grub-bios" "grub-efi-dualboot" "systemd-boot" ];
      default = "none";
      description = ''
        Which bootloader to install:
        - grub-bios:         legacy GRUB on a specific disk device
        - grub-efi-dualboot: EFI GRUB with cryptodisk + OS prober + memtest
        - systemd-boot:      lightweight EFI bootloader (no Linux/Win dualboot)
      '';
    };

    plymouth.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Boot splash via Plymouth (with the theme from custom_vars.plymouthTheme).";
    };
  };

  config = mkMerge [
    # ── Common GRUB skeleton (BIOS or EFI dualboot share the same UI) ────────
    (mkIf (cfg.loader == "grub-bios" || cfg.loader == "grub-efi-dualboot") {
      boot.loader.systemd-boot.enable = mkForce false;

      boot.loader.grub = {
        enable             = true;
        useOSProber        = true;
        configurationLimit = 20;
        splashImage        = ./bg.png;
        font               = "${grubFont}/DejaVuSansMono36.pf2";
        extraConfig        = ''
          set color_highlight=black/white
        '';
      };
      boot.loader.timeout = 60;
    })

    # ── GRUB on BIOS: install onto the configured boot device ────────────────
    (mkIf (cfg.loader == "grub-bios") {
      boot.loader.grub.device = vars.bootDevice;
    })

    # ── GRUB on EFI (dualboot): cryptodisk, memtest, devices=[nodev] ─────────
    (mkIf (cfg.loader == "grub-efi-dualboot") {
      boot.loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint     = "/boot";
      };
      boot.loader.grub = {
        efiSupport       = true;
        enableCryptodisk = true;
        memtest86.enable = true;
        devices          = [ "nodev" ];
        device           = mkForce "nodev";
      };
    })

    # ── systemd-boot ─────────────────────────────────────────────────────────
    (mkIf (cfg.loader == "systemd-boot") {
      boot.loader.systemd-boot.enable      = true;
      boot.loader.efi.canTouchEfiVariables = true;
    })

    # ── Plymouth ─────────────────────────────────────────────────────────────
    (mkIf cfg.plymouth.enable {
      boot.initrd.systemd.enable = true;

      # Drop-in: extend LUKS password timeout to 30 min (only affects
      # cryptsetup units). Complements rd.luks.options=timeout=0 — kernel
      # waits forever for input, systemd caps the unit at 30 min so a stuck
      # prompt eventually reboots.
      boot.initrd.systemd.units."systemd-cryptsetup@.service.d/timeout.conf".text = ''
        [Service]
        TimeoutSec=1800
      '';

      boot.plymouth = {
        enable = true;
        theme = "${vars.plymouthTheme}";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "${vars.plymouthTheme}" ];
          })
        ];
        extraConfig = ''
          InputTimeout=0
          Font=DejaVu Sans 32
        '';
      };

      boot.consoleLogLevel = 0;
      boot.initrd.verbose  = false;

      boot.kernelParams = mkBefore [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=4"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "plymouth.enable-logo=false"
        "plymouth.debug=true"
        "plymouth.ignore-serial-consoles"
        "rd.luks.options=timeout=0"
        "rd.timeout=0"
        "rootflags=x-systemd.device-timeout=0"
      ];

      environment.systemPackages = with pkgs; [
        adi1090x-plymouth-themes
        plymouth
      ];
    })
  ];
}
