{ config, lib, pkgs, modulesPath, ... }:

{
  # Sound configuration
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = lib.mkDefault true;
    wireplumber.enable = true;
  };

  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
        pipewire
        wireplumber
        pavucontrol
        pulseaudio
    ])
  ];
}
