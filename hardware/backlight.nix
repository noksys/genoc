# Backlight: a `bright` CLI for percentage-based control over
# /sys/class/backlight/intel_backlight, plus a one-shot service that
# sets the panel to 50% on boot. MAX=496 is the Legion Pro 7 Gen9 panel
# max brightness; on different hardware override `genoc.hardware.backlight.max`.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.hardware.backlight;
  bright = pkgs.writeShellScriptBin "bright" ''
    MAX=${toString cfg.max}
    if [ -z "$1" ]; then
      current=$(cat /sys/class/backlight/intel_backlight/brightness)
      echo $(( current * 100 / MAX ))%
    elif [ "$1" -ge 0 ] 2>/dev/null && [ "$1" -le 100 ] 2>/dev/null; then
      echo $(( $1 * MAX / 100 )) | sudo tee /sys/class/backlight/intel_backlight/brightness > /dev/null
      echo "Brightness set to $1%"
    else
      echo "Usage: bright [0-100]"
      exit 1
    fi
  '';
in {
  options.genoc.hardware.backlight = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    max = mkOption {
      type = types.int;
      default = 496;
      description = "Panel max brightness (sysfs raw value).";
    };
    bootPercent = mkOption {
      type = types.int;
      default = 50;
      description = "Brightness to set on boot, in percent.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ bright ];

    systemd.services.backlight-default = {
      description = "Set default backlight brightness on boot";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/bin/sh -c 'echo ${toString (cfg.max * cfg.bootPercent / 100)} > /sys/class/backlight/intel_backlight/brightness'";
      };
    };
  };
}
