# Bluetooth stack: bluez + experimental features (battery report, MPRIS),
# blueman tray, xpadneo (Xbox controller), MPRIS proxy bridge for media
# keys, and the wireplumber bluetooth enhancements (aptX/AAC/SBC-XQ
# codecs, HFP/HSP for headset mics).
{ config, lib, pkgs, ... }:

with lib;

{
  options.genoc.hardware.bluetooth.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf config.genoc.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";   # all profiles + media control
          Experimental = true;                    # battery report, MPRIS, etc.
        };
      };
    };
    services.blueman.enable = true;
    hardware.xpadneo.enable = true;

    # Bridges Bluetooth media keys (play/pause/next) to MPRIS so KDE
    # shortcuts work with BT headphones.
    systemd.user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = [ "network.target" "sound.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };

    # PipeWire: better BT codecs (aptX/AAC/SBC-XQ) and HFP/HSP for headset mic.
    services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq"     = true;
        "bluez5.enable-msbc"       = true;
        "bluez5.enable-hw-volume"  = true;
        "bluez5.roles"             = [ "a2dp_sink" "a2dp_source" "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        "bluez5.a2dp.codecs"       = [ "sbc" "aac" ];
      };
    };

    environment.systemPackages = [ pkgs.bluez ];
  };
}
