{ config, lib, pkgs, ... }:

let
  vars = import ../../custom_vars.nix;
  user = vars.mainUser;
  home = vars.homeDirectory;

  # Path to the refresh rate script (relative to this file)
  refreshScript = ../bin/refresh-smart.sh;
in
{
  # =============================================================================
  # UDEV RULE: Trigger service when AC power is plugged/unplugged
  # =============================================================================
  # This rule detects power supply changes and dispatches to systemd user service
  # instead of running commands directly (which would lack X11/Wayland access)
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="refresh-smart-ac.service"
  '';

  # =============================================================================
  # SERVICE: Refresh rate on AC power change (udev-triggered)
  # =============================================================================
  # Runs when udev detects AC plug/unplug events
  # Already has proper X11 access since it runs in user context
  systemd.user.services.refresh-smart-ac = {
    description = "Refresh screen rate on power change";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${refreshScript}";
      # Ensure all required binaries are in PATH
      Environment = "PATH=${pkgs.xorg.xrandr}/bin:${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:${pkgs.bash}/bin";
    };
  };

  # =============================================================================
  # SERVICE: Refresh rate on login/session start
  # =============================================================================
  # Runs when graphical session starts, but with retry logic since X11/Wayland
  # might not be fully initialized yet when graphical-session.target is reached
  systemd.user.services.refresh-smart-startup = {
    description = "Refresh screen rate on login";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      # Wrapper script that waits for display to be available before running
      ExecStart = pkgs.writeShellScript "refresh-with-wait.sh" ''
        # Wait up to 30 seconds for X11/Wayland display to become available
        # This prevents race conditions during login
        for attempt in {1..30}; do
          # Test if xrandr can query the display successfully
          if ${pkgs.xorg.xrandr}/bin/xrandr --query &>/dev/null; then
            echo "[refresh-smart] Display ready after $attempt seconds, executing refresh..."
            ${refreshScript}
            exit 0
          fi

          # Display not ready yet, wait 1 second before retry
          sleep 1
        done

        # If we reach here, display never became available
        echo "[refresh-smart] ERROR: Timeout waiting for display after 30 seconds" >&2
        exit 1
      '';
    };
  };
}
