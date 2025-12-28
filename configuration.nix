{ pkgs, ... }:

let
  vars = import ../custom_vars.nix;
in
{
  imports =
    [
      # Custom user config (Expected to be in the parent directory)
      ../custom_machine.nix

      # Core Modules
      ./modules/sys-utils-base.nix
    ];

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.nixos-cuda.org"
      "https://noksys.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  # Network
  networking.hostName = vars.hostName;

  # Users
  users.mutableUsers = false;

  users.users.root = {
    isNormalUser = false;
    hashedPassword = vars.rootHashedPassword;
  };

  users.users.${vars.mainUser} = {
    isNormalUser = true;
    hashedPassword = vars.userHashedPassword;
    description = vars.userFullName;
    extraGroups = [ ]; # Groups are added by modules
    # Packages should be defined in custom_machine.nix or profiles
  };

  # System Settings
  time.timeZone = vars.timeZone;
  i18n.defaultLocale = "en_US.UTF-8";
  services.timesyncd.enable = true;

  # Console
  console.keyMap = vars.defaultConsoleKeyMap;

  # Nix Settings
  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Shell Init (History, Auto-logout)
  environment.interactiveShellInit = ''
    if [ "$TERM" = linux ]; then
      TMOUT=600
      export TMOUT
    fi
  '';
  
  environment.shellInit = ''
    if [ -n "$BASH_VERSION" ]; then
      export HISTCONTROL=ignoreboth
    fi
    if [ -n "$ZSH_VERSION" ]; then
      setopt HIST_IGNORE_SPACE
    fi
  '';

  # System Version
  system.stateVersion = vars.installationNixOSVersion;
  system.autoUpgrade.enable = true;
  system.copySystemConfiguration = true;
}
