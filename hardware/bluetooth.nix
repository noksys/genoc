{ config, lib, pkgs, modulesPath, hardware, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };

  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
    load-module module-bluetooth-policy
    load-module module-bluetooth-discover
    ## module fails to load with
    ##   module-bluez5-device.c: Failed to get device path from module arguments
    ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    # load-module module-bluez5-device
    # load-module module-bluez5-discover
    '';

  hardware.pulseaudio = {
    package = lib.mkDefault pkgs.pulseaudioFull;
  };

  hardware.pulseaudio.extraConfig = "
    load-module module-switch-on-connect
    ";

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
        bluez
    ])
  ];
}
