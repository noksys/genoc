{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../../../custom_vars.nix;
in
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

  users.users.${vars.mainUser}.extraGroups = [ "audio" ];

  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
    calf        # LV2 plugins
    easyeffects # Audio effects for PipeWire
    lsp-plugins # LSP audio plugins
    mda_lv2     # MDA LV2 plugins
    pavucontrol # PulseAudio volume control
    pipewire    # PipeWire daemon
    pulseaudio  # PulseAudio compatibility
    wireplumber # PipeWire session manager
    yelp        # Help viewer (docs)
    zam-plugins # ZAM audio plugins
    alsa-utils  # ALSA utilities
    alsa-tools  # ALSA tools
  ];
}
