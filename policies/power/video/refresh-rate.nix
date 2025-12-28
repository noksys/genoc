{ config, pkgs, lib, ... }:

let
  # The smart refresh script loaded from a separate file
  refreshScript = pkgs.writeShellScript "refresh-smart"
    (builtins.replaceStrings
      [ "@PATH@" ]
      [ (lib.makeBinPath [ pkgs.xorg.xrandr pkgs.gawk pkgs.coreutils pkgs.gnused ]) ]
      (builtins.readFile ./refresh-rate.sh)
    );
in
{
  # 1. Trigger via Udev when power source changes
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="refresh-smart-ac.service"
    SUBSYSTEM=="power_supply", ATTR{type}=="USB_C", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="refresh-smart-ac.service"
  '';

  # 2. The User Service that runs the script
  systemd.user.services.refresh-smart-ac = {
    description = "Smart Refresh Rate (AC/Bat)";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${refreshScript}";
      TimeoutSec = "10";
    };
  };

  # 3. Run on Startup (wait for display)
  systemd.user.services.refresh-smart-startup = {
    description = "Smart Refresh Rate (Startup)";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    script = ''
      # Wait for Xrandr to be ready
      for i in {1..30}; do
        if ${pkgs.xorg.xrandr}/bin/xrandr >/dev/null 2>&1; then
           echo "Display ready, executing refresh..."
           exec ${refreshScript}
           exit 0
        fi
        sleep 1
      done
      echo "Timeout waiting for display" >&2
      exit 1
    '';
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = "35";
    };
  };
}
