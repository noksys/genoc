# /etc/nixos/mica-nixos/genoc/battery/refresh-smart.nix
#
# Set panel refresh rate based on power source:
# - User service: runs once per graphical login
# - System service: fired by udev on AC adapter plug/unplug
# - Wraps your repo script with PATH + DISPLAY/XAUTH discovery

{ config, lib, pkgs, ... }:

let
  # Shared vars (your file)
  vars = import ../../custom_vars.nix;
  user = vars.mainUser;
  home = (vars.homeDirectory or "/home/${vars.mainUser}");

  # Read your upstream script from ../bin (relative to this .nix)
  upstreamScript = pkgs.writeText "refresh-smart.upstream.sh"
    (builtins.readFile ../bin/refresh-smart.sh);

  # Wrapper that:
  #   - ensures required tools on PATH
  #   - discovers DISPLAY and XAUTHORITY if not set
  #   - then runs your upstream script
  refreshSmart = pkgs.writeShellApplication {
    name = "refresh-smart";
    runtimeInputs = with pkgs; [
      xorg.xrandr
      coreutils
      gnugrep
      gnused
      gawk
      findutils
      bash
    ];
    text = ''
      set -euo pipefail

      # --- Discover DISPLAY if not set ---
      if [ -z "''${DISPLAY:-}" ]; then
        if [ -d /tmp/.X11-unix ]; then
          # Use find instead of ls (handles odd filenames & keeps ShellCheck happy)
          d=$(find /tmp/.X11-unix -maxdepth 1 -type s -name 'X*' -printf '%f\n' 2>/dev/null \
                | sed 's/^X//' | sort -n | tail -1 || true)
          [ -n "''${d:-}" ] && export DISPLAY=":''${d}"
        fi
        # Fallback
        export DISPLAY="''${DISPLAY:-:0}"
      fi

      # --- Discover XAUTHORITY if not set ---
      if [ -z "''${XAUTHORITY:-}" ]; then
        uid=$(id -u)
        # Prefer newest Xauthority-y file under /run/user/$uid (SDDM/KDE X11)
        newest_xauth=$(find "/run/user/''${uid}" -maxdepth 1 -type f -name 'xauth_*' -printf '%T@ %p\n' 2>/dev/null \
                         | sort -nr | awk 'NR==1{print $2}')
        for cand in "''${newest_xauth:-}" "/run/user/''${uid}/gdm/Xauthority" "''${HOME}/.Xauthority"
        do
          if [ -n "''${cand}" ] && [ -r "''${cand}" ]; then
            export XAUTHORITY="''${cand}"
            break
          fi
        done
      fi

      # Helpful diagnostic if xrandr cannot talk to X
      if ! xrandr -q >/dev/null 2>&1; then
        echo "⚠ xrandr cannot access display (DISPLAY=''${DISPLAY:-unset}, XAUTHORITY=''${XAUTHORITY:-unset})" >&2
      fi

      # Run your upstream logic
      exec ${pkgs.bash}/bin/bash ${upstreamScript}
    '';
  };

in
{
  # Handy for interactive tests
  environment.systemPackages = [ pkgs.xorg.xrandr ];

  # User service: runs once after graphical session is up
  systemd.user.services.refresh-smart = {
    description = "Set panel refresh rate by power source (per-session)";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${refreshSmart}/bin/refresh-smart";
      StandardOutput = "journal";
      StandardError  = "journal";
    };
  };

  # System service: launched by udev on AC plug/unplug
  systemd.services.refresh-smart = {
    description = "Set panel refresh rate by power source (udev trigger)";
    serviceConfig = {
      Type = "oneshot";
      User = user;                 # run as desktop user so /run/user/$UID is accessible
      WorkingDirectory = home;
      ExecStart = "${refreshSmart}/bin/refresh-smart";
      StandardOutput = "journal";
      StandardError  = "journal";
    };
  };

  # udev rule: trigger on AC mains state changes
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_TYPE}=="Mains", \
      TAG+="systemd", ENV{SYSTEMD_WANTS}+="refresh-smart.service"
  '';
}
