# Auto-switch screen refresh rate on AC plug/unplug (saves battery on
# panels that support 60/90/120/165Hz). Triggered by udev power_supply
# events for Mains and USB_C — Legion Pro 7 charges via USB-C, so the
# USB_C variant is mandatory there.
{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../custom_vars.nix;
  user = vars.mainUser;
  home = vars.homeDirectory;
  refreshScript = ../bin/refresh-smart.sh;
in {
  options.genoc.battery.refreshSmart.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Refresh-rate auto-switching on AC change.";
  };

  config = mkIf config.genoc.battery.refreshSmart.enable {
    # Trigger service when AC / USB-C power is plugged/unplugged. Dispatches
    # to a systemd user service so the script has X11/Wayland access.
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{type}=="Mains", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="refresh-smart-ac.service"
      SUBSYSTEM=="power_supply", ATTR{type}=="USB_C", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="refresh-smart-ac.service"
    '';

    systemd.user.services.refresh-smart-ac = {
      description = "Refresh screen rate on power change";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${refreshScript}";
        Environment = "PATH=${pkgs.xorg.xrandr}/bin:${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:${pkgs.bash}/bin";
      };
    };

    systemd.user.services.refresh-smart-startup = {
      description = "Refresh screen rate on login";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        # Wrapper script that waits for display to be available before running
        # (X11/Wayland might not be initialized at graphical-session.target).
        ExecStart = pkgs.writeShellScript "refresh-with-wait.sh" ''
          for attempt in {1..30}; do
            if ${pkgs.xorg.xrandr}/bin/xrandr --query &>/dev/null; then
              echo "[refresh-smart] Display ready after $attempt seconds, executing refresh..."
              ${refreshScript}
              exit 0
            fi
            sleep 1
          done
          echo "[refresh-smart] ERROR: Timeout waiting for display after 30 seconds" >&2
          exit 1
        '';
      };
    };
  };
}
