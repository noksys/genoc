{ config, lib, pkgs, modulesPath, ... }:

{
  # Sound configuration
  sound.enable = true;

  # PipeWire configuration
  services.pipewire = {
    enable = false;
    alsa.enable = false;
    alsa.support32Bit = false;
    pulse.enable = false;
    # Uncomment to enable JACK for JACK applications
    # jack.enable = true;

    # Example session manager (default enabled, no need to redefine)
    # media-session.enable = true;
  };

  # PulseAudio configuration
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraConfig = "
      load-module module-combine-sink
      load-module module-switch-on-connect
    ";
  };

  # Disable real-time scheduling daemon (RTKit)
  security.rtkit.enable = lib.mkForce false;

  # Configure Pulseaudio globally in nixpkgs
  nixpkgs.config.pulseaudio = true;
}
