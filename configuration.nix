{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../custom_vars.nix;
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports =
    [
      # Custom user config
      #../custom_machine.nix
      /etc/nixos/mica-nixos/mantis-legion-pro-7/custom_machine.nix
    ];

  programs.dconf.enable = true;

  # zfs stuff
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.kernelPackages = latestKernelPackage;
  # Note: zfs.zfs_arc_max moved to ./hardware/zfs.nix (machine-imported).
  # rd.luks.timeout=1800 keeps the kernel-level LUKS prompt at 30min;
  # genoc/boot/plymouth.nix adds a complementary systemd-level cap.
  boot.kernelParams = [ "rd.luks.timeout=1800" ];
  #boot.extraModprobeConfig = ''
  #   options zfs l2arc_noprefetch=0 l2arc_write_boost=33554432 l2arc_write_max=16777216 zfs_arc_max=2147483648
  #'';

  # Bash scripts compatibility
  system.activationScripts.binsh = {
    deps = [ "usrbinenv" ];
    text = ''
      mkdir -p /bin
      mkdir -p /usr/bin

      ln -sf ${pkgs.bash}/bin/bash /bin/bash
      ln -sf ${pkgs.bash}/bin/sh /bin/sh
      ln -sf ${pkgs.dash}/bin/dash /bin/dash || ln -sf ${pkgs.bash}/bin/bash /bin/dash
      ln -sf ${pkgs.coreutils}/bin/env /usr/bin/env
      ln -sf ${pkgs.coreutils}/bin/env /bin/env
      ln -sf ${pkgs.python3}/bin/python3 /usr/bin/python3
      ln -sf ${pkgs.python3}/bin/python /usr/bin/python
      ln -sf ${pkgs.perl}/bin/perl /usr/bin/perl
    '';
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  boot.kernelModules = [ "zfs" ];

  environment.interactiveShellInit = ''
    # Auto-logout
    if [ "$TERM" = linux ]; then
      TMOUT=600
      export TMOUT
    fi
  '';

  environment.shellAliases = {
    chez = "scheme";
    # The antigravity-cli package only installs `agy`.
    antigravity = "agy";
    # Force WezTerm onto the NVIDIA dGPU via PRIME render offload.
    wezterm = "__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia command wezterm";
  };

  #
  # IMPORTANT!
  #
  # ACTION: You need to edit `custom_vars.nix` and `custom_machine.nix` to
  #         suit your needs.
  #

  # Network
  networking = {
    hostName = vars.hostName;
    enableIPv6 = true;

    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  networking.networkmanager.unmanaged = [
    # Docker
    "interface-name:docker*"
    "interface-name:br-*"
    "interface-name:veth*"

    # Libvirt / KVM
    "interface-name:virbr*"
    "interface-name:vnet*"
    "interface-name:tap*"
    "interface-name:tun*"
  ];

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" "9.9.9.9" ];

  security.polkit.enable = true;

  hardware.wirelessRegulatoryDatabase = true;

  # boot.extraModprobeConfig = ''
  #   options cfg80211 ieee80211_regdom="UY"
  # '';

  boot.kernel.sysctl."net.ipv6.conf.all.disable_ipv6" = false;
  # Magic SysRq fully enabled (=1). 244 already allowed full REISUB, but it
  # blocked the debug dumps (SysRq+w/l/t backtraces) needed to diagnose the
  # mantis freezes (2026-06/07). Note: =1 also enables crash(c) = deliberate panic.
  boot.kernel.sysctl."kernel.sysrq" = 1;
  # Keep idle long-running TCP connections alive (Telegram/Signal/SSH on flaky NAT).
  boot.kernel.sysctl."net.ipv4.tcp_keepalive_time" = 60;
  boot.kernel.sysctl."net.ipv4.tcp_keepalive_intvl" = 30;
  boot.kernel.sysctl."net.ipv4.tcp_keepalive_probes" = 6;

  # System optimization & hacks
  fileSystems."/".options = lib.mkDefault [ "noatime" ];

  # configurationLimit moved to ./boot/grub.nix (= 20, brought from v2.x).
  boot.initrd.availableKernelModules = lib.mkMerge [ [ "dm_crypt" "zfs" ] ];

  system = {
    copySystemConfiguration = true;
  };

  systemd.services.nix-daemon.serviceConfig = {
    Nice = 6;
    IOWeight = 100;
  };

  # Shutdown timeouts — default systemd is 90s per service.
  # The user@1000.service was hanging for ~1m49s waiting for some KDE
  # background service to terminate; cap shutdown at 15s for both system
  # and user managers. After 15s a SIGKILL ends the holdout.
  systemd.settings.Manager.DefaultTimeoutStopSec = "15s";
  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  nix.settings.auto-optimise-store = true;

  #environment.sessionVariables = {
  #  LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.libuuid]}:$#{pkgs.stdenv.cc.cc.lib}/lib";
  #};

  time.timeZone = vars.timeZone;
  i18n.defaultLocale = "en_US.UTF-8";
  services.timesyncd.enable = true;

  # FHS emulation for /bin and /usr/bin via a FUSE fs (returns symlinks to
  # executables resolved from the caller's PATH). Needed by tools that hardcode
  # FHS paths like /bin/sleep or /usr/bin/socat — notably the Claude Science
  # sandbox: bwrap ro-binds the host /bin+/usr/bin, and its conda/micromamba
  # shell scripts call coreutils/socat by bare name, which fail on a stock NixOS
  # /bin (only sh/bash). See ~/app/claude-science and the claude-science wrapper.
  services.envfs.enable = true;

  services.xserver = {
    # Configure XKB with US Intl as default + PT-BR ABNT2 as alternate
    # (Shift+Shift to toggle). v3 follows v2's order — physical EN-INT
    # keyboards expect US Intl active by default.
    xkb = {
      layout = "us,br";
      variant = "intl,abnt2";
      options = "grp:shifts_toggle";
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Console keymap for non-X11 environment
  console.keyMap = vars.defaultConsoleKeyMap;

  # Printing
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = false;
    #openFirewall = true;  # For WiFi printers
  };

  # Sudo Configuration
  security.sudo = {
    wheelNeedsPassword = false;
    enable = true;
    # Narrow passwordless set. These stay NOPASSWD on purpose: they are the
    # scheduled sleep/wake automation, none of them can yield a root shell, and
    # with genoc.security.sudo2fa the blanket NOPASSWD: ALL is gone, so anything
    # missing from this list would start demanding a YubiKey touch mid-script.
    extraRules = [{
      commands = [
        # /run/current-system paths rather than store paths: sudoers matches the
        # command literally without resolving symlinks, and what actually gets
        # invoked comes from PATH. A store path would also break silently on every
        # nixpkgs bump, since the hash changes and the rule stops matching.
        { command = "/run/current-system/sw/bin/systemctl suspend"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl hibernate"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl hybrid-sleep"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl suspend-then-hibernate"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/rtcwake"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/reboot"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/poweroff"; options = [ "NOPASSWD" ]; }
      ];
      groups = [ "wheel" ];
    }];
  };

  # User config
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.bash;

  users.users.root = {
    isNormalUser = false;
    hashedPassword = vars.rootHashedPassword;
  };

  users.users.${vars.mainUser} = {
    isNormalUser = true;
    hashedPassword = vars.userHashedPassword;
    description = vars.userFullName;
    # "docker" deliberately absent: membership is equivalent to passwordless
    # root via the daemon socket, which would undo sudo hardening. Containers
    # run through the rootless daemon instead (genoc/profiles/dev.nix).
    extraGroups = [ "networkmanager" "nginx" "wheel" "audio" "tarsnap" "lp" "tor" "debian-tor" "plugdev" "dialout" ];
    # Per-user packages live in profiles or in machine config (e.g.,
    # KDE-specific user packages in genoc/ui/kde.nix).
    packages = [];
  };

  # Nix Configuration
  nixpkgs.config = {
    allowUnfree = true;
    joypixels.acceptLicense = true;
    firefox.speechSynthesisSupport = true;
  };

  # Nix settings for flakes
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # GPG agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      AuthenticationMethods = "publickey,password";
    };
  };

  # Tor Service Configuration
  services.tor = {
    enable = true;
    enableGeoIP = false;
    torsocks.enable = true;
#    openFirewall = true;
    client.enable = true;
    relay.enable = false;

#     relay = {
#       enable = true;
#       role = "relay";  # Set the relay role (e.g., "relay", "bridge")
#     };

    settings = {
      #Nickname = "Lazy Guy";
      #ContactInfo = "lazyguy@example.com";

      MaxAdvertisedBandwidth = "10 MB";
      BandWidthRate = "5 MB";
      BandwidthBurst = "10 MB";
      #RelayBandwidthRate = "5 MB";
      #RelayBandwidthBurst = "10 MB";

      # Restrict exit nodes to a specific country (use the appropriate country code)
      #ExitNodes = "{ch} StrictNodes 1";

      # Reject all exit traffic
      ExitPolicy = ["reject *:*"];

      # Performance and security settings
      CookieAuthentication = true;
      CookieAuthFileGroupReadable = true;
      DataDirectoryGroupReadable = true;
      AvoidDiskWrites = 1;
      HardwareAccel = 1;

      ControlPort = 9051;
      HashedControlPassword = "${vars.torControlPasswordHash}";

      # Network settings
      #ORPort = [443];

      #Log = "debug stderr";
      SafeLogging = 1;
    };
  };

  # PCSCD
  services.pcscd.enable = true;

  # cpupower-gui needs its dbus/systemd service to do privileged frequency
  # changes; without it the GUI fails to start.
  services.cpupower-gui.enable = true;

  # HDR support
  services.colord.enable = true;

  # GC
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
    persistent = true;
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Commands with space at start won't be saved:
  environment.shellInit = ''
    if [ -n "$BASH_VERSION" ]; then
      export HISTCONTROL=ignoreboth
    fi

    if [ -n "$ZSH_VERSION" ]; then
      setopt HIST_IGNORE_SPACE
    fi
  '';

  powerManagement.powertop.enable = false;

  # Economic Powersave mode
  specialisation = {
    powersave.configuration = {
      networking.networkmanager.wifi.powersave = lib.mkForce true;
      boot.tmp.useTmpfs = true;
      services.journald.extraConfig = "SystemMaxUse=100M";
      powerManagement.powertop.enable = lib.mkForce true;
      boot.kernel.sysctl = {
        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
        # Reduce timer wakeups and disable kernel watchdog to save CPU cycles.
        "kernel.nmi_watchdog" = 0;
        "kernel.timer_migration" = 0;
        # Buffer more dirty pages in RAM (writeback delayed → fewer disk flushes).
        "vm.dirty_ratio" = 60;
        "vm.dirty_background_ratio" = 40;
        # Allow lazytime mtime/atime updates to age 24h before flushing.
        "vm.dirtytime_expire_seconds" = 86400;
      };

      boot.kernelParams = [
        "intel_pstate=passive"           # kernel takes the freq decisions (no HWP delegation)
        "pcie_aspm=force"                # force PCIe ASPM L1
        "pcie_aspm.policy=powersupersave" # most aggressive ASPM policy
        "nosmt"                          # disable SMT/Hyper-Threading (lower idle floor)
        "nvme_core.default_ps_max_latency_us=5500"  # let NVMe enter PS4 deep idle
        "i915.enable_dc=4"               # iGPU display engine deep-sleep states
        "i915.enable_psr=1"              # panel self-refresh
        "i915.enable_fbc=1"              # framebuffer compression
        "usbcore.autosuspend=1"          # autosuspend USB devices after 1s idle
      ];
      services.thermald.enable = lib.mkForce true;

      # Bluetooth + Xbox controller off in powersave (saves ~0.5W idle).
      hardware.bluetooth.enable = lib.mkForce false;
      hardware.bluetooth.powerOnBoot = lib.mkForce false;
      services.blueman.enable = lib.mkForce false;
      hardware.xpadneo.enable = lib.mkForce false;

      # NOTE: snd_hda_intel power_save stays OFF even in powersave: with
      # power_save=1 the speakers (TAS2781) desync from the ALC287 and go
      # silent. We inherit power_save=0 from the machine module
      # (hardware/lenovo-legion-pro7-16irx9h.nix). The old snd_ac97_codec line
      # was inert (no AC'97 on this machine).

      # Drop screen brightness to 30% (148 / 496 max) when entering powersave.
      # Overrides the genoc/hardware/backlight.nix backlight-default that sets 50%.
      systemd.services.backlight-default.serviceConfig.ExecStart =
        lib.mkForce "/bin/sh -c 'echo 148 > /sys/class/backlight/intel_backlight/brightness'";

      systemd.services.override-sysctl = {
        description = "Override sysctl after powertop";
        after = [ "powertop.service" ];
        # NOTE: previously wantedBy=multi-user.target — caused an ordering
        # cycle (override-sysctl had implicit Before=multi-user, powertop
        # had After=multi-user). Pulling it via powertop.service breaks
        # the cycle: powertop runs after multi-user, then override-sysctl
        # runs after powertop.
        wantedBy = [ "powertop.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "override-sysctl.sh" ''
            echo 5 > /proc/sys/vm/laptop_mode
            echo 6000 > /proc/sys/vm/dirty_writeback_centisecs
          '';
        };
      };
    };
  };

  # Insecure packages allowed at the genoc level. librewolf is flagged insecure
  # in nixpkgs (no active maintainer); permit it BY NAME via a predicate so a
  # rolling-channel bump (151 -> 152 -> ...) never re-breaks the build the way a
  # pinned version list does. For one-off insecure pkgs add exact names below.
  nixpkgs.config.allowInsecurePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "librewolf"
      "librewolf-unwrapped"

      # python-ecdsa, pulled in by python3Packages.ckcc-protocol (the Coldcard
      # 'ckcc' CLI, hardware/coldcard.nix). Flagged for CVE-2024-23342
      # (Minerva): the library is pure Python, is not side-channel resistant,
      # and upstream states it will not be made so — the flag is permanent, not
      # a pending fix to wait out.
      #
      # The attack recovers a private key from timing while that key signs
      # locally. On this machine the keys live on the Coldcard and never reach
      # the host, so nothing here signs with a secret scalar. Not audited
      # further than that: ckcc-protocol's own use of the library was not read.
      #
      # By name rather than by version, for the reason in the comment above:
      # a channel bump to 0.19.2 must not re-break the build.
      "ecdsa"
    ];
  nixpkgs.config.permittedInsecurePackages = [
    # e.g. "gradle-7.6.6" — exact-version entries (predicate already covers librewolf)
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = vars.installationNixOSVersion; # Did you read the comment?
  system.autoUpgrade.enable = true;
}
