{ config, lib, pkgs, modulesPath, ... }:

{
  # Sound configuration
  sound.enable = true;

  # PulseAudio configuration
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraConfig = "
      load-module module-combine-sink
      load-module module-switch-on-connect
      load-module module-equalizer-sink
      load-mudule module-dbus-protocol
    ";
  };

  # Disable real-time scheduling daemon (RTKit)
  security.rtkit.enable = lib.mkForce false;

  # Configure Pulseaudio globally in nixpkgs
  nixpkgs.config.pulseaudio = true;

    environment.systemPackages = lib.mkMerge [
    (with pkgs; [
        pavucontrol
        pulseaudio
    ])
  ];
}
