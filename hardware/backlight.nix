{ pkgs, ... }:

let
  bright = pkgs.writeShellScriptBin "bright" ''
    MAX=496
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
in
{
  environment.systemPackages = [ bright ];

  # Set default backlight brightness to 50% on boot.
  systemd.services.backlight-default = {
    description = "Set default backlight brightness to 50%";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'echo 248 > /sys/class/backlight/intel_backlight/brightness'";
    };
  };
}
