{ config, lib, pkgs, modulesPath, ... }:

{
  # Sound configuration
  # sound.enable = true; // Deprecated?
  services.pulseaudio.enable = false;

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
        calf
        easyeffects
        lsp-plugins
        mda_lv2
        pavucontrol
        pipewire
        pulseaudio
        wireplumber
        yelp
        zam-plugins
        alsa-utils
        alsa-tools
    ])
  ];
}
