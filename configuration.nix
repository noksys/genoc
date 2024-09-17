{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../custom_vars.nix;
in
{
  imports =
    [
      # Custom user config
      ../custom_machine.nix
    ];

  #
  # IMPORTANT!
  #
  # ACTION: You need to edit `custom_vars.nix` and `custom_machine.nix` to
  #         suit your needs.
  #

  # Network
  networking.hostName = vars.hostName;

  # System optimization & hacks
  fileSystems."/".options = lib.mkDefault [ "noatime" ];

  boot.loader.grub.configurationLimit = 5;
  boot.initrd.availableKernelModules = lib.mkMerge [ [ "dm_crypt" ] ];

  system = {
    copySystemConfiguration = true;
  };

  systemd.services.nix-daemon.serviceConfig = {
    Nice = 6;
    IOWeight = 100;
  };

  nix.settings.auto-optimise-store = true;

  environment.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.libuuid]}:${pkgs.stdenv.cc.cc.lib}/lib";
  };

  time.timeZone = vars.timeZone;
  i18n.defaultLocale = "en_US.UTF-8";

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
    openFirewall = true;  # For WiFi printers
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
  users.defaultUserShell = pkgs.bash;

  users.users.${vars.mainUser} = {
    isNormalUser = true;
    description = vars.userFullName;
    extraGroups = [ "networkmanager" "wheel" "audio" "tarsnap" "lp" ];
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
    package = pkgs.nixFlakes;
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
  services.openssh.enable = true;

  # Tor Service Configuration
  services.tor = {
    enable = true;
    enableGeoIP = false;
    client.enable = true;
    relay.enable = false;
  };

  # To avoid any issues with Windows automatic sync time on dual boot machine
  time.hardwareClockInLocalTime = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = vars.installationNixOSVersion; # Did you read the comment?
  system.autoUpgrade.enable = true;
}
