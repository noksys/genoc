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
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" "rd.luks.timeout=1800" ];
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

  networking.nameservers = [ "8.8.8.8" "8.8.4.4" "1.1.1.1" ];

  security.polkit.enable = true;

  hardware.wirelessRegulatoryDatabase = true;

  # boot.extraModprobeConfig = ''
  #   options cfg80211 ieee80211_regdom="UY"
  # '';

  boot.kernel.sysctl."net.ipv6.conf.all.disable_ipv6" = false;
  boot.kernel.sysctl."kernel.sysrq" = "1";

  # System optimization & hacks
  fileSystems."/".options = lib.mkDefault [ "noatime" ];

  boot.loader.grub.configurationLimit = 5;
  boot.initrd.availableKernelModules = lib.mkMerge [ [ "dm_crypt" "zfs" ] ];

  system = {
    copySystemConfiguration = true;
  };

  systemd.services.nix-daemon.serviceConfig = {
    Nice = 6;
    IOWeight = 100;
  };

  nix.settings.auto-optimise-store = true;

  #environment.sessionVariables = {
  #  LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.libuuid]}:$#{pkgs.stdenv.cc.cc.lib}/lib";
  #};

  time.timeZone = vars.timeZone;
  i18n.defaultLocale = "en_US.UTF-8";
  services.timesyncd.enable = true;

  services.xserver = {
    # Configure XKB with multiple layouts (BR and US with SHIFT+SHIFT alternation)
    xkb = {
      layout = "br,us";              # First layout is Brazilian (br), second is US (us)
      variant = ",alt-intl";         # No variant for "br", "alt-intl" for the "us" layout
      options = "grp:shifts_toggle"; # Toggle between layouts with Shift+Shift
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
    extraRules = [{
      commands = [
        { command = "${pkgs.systemd}/bin/systemctl suspend"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.systemd}/bin/reboot"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.systemd}/bin/poweroff"; options = [ "NOPASSWD" ]; }
      ];
      groups = [ "wheel" "docker" ];
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
    extraGroups = [ "networkmanager" "nginx" "wheel" "audio" "tarsnap" "lp" "tor" "debian-tor" "plugdev" "docker" ];
    packages = lib.mkMerge [
      (import ./pkgs/default_user.nix { pkgs = pkgs; })
    ];
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

  # HDR support
  services.colord.enable = true;

  # GC
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
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
      };

      boot.kernelParams = [ "intel_pstate=passive" "pcie_aspm=force" ];
      services.thermald.enable = lib.mkForce true;

      boot.extraModprobeConfig = ''
        options snd_hda_intel power_save=1
        options snd_ac97_codec power_save=1
      '';

      systemd.services.override-sysctl = {
        description = "Override sysctl after powertop";
        after = [ "powertop.service" ];
        wantedBy = [ "multi-user.target" ];
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

  nixpkgs.config.permittedInsecurePackages = [
  #  "python3.12-ecdsa-0.19.1"
    "gradle-7.6.6"
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
