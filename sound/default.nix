# Audio stack: PipeWire (default), PulseAudio (legacy fallback), or
# none. PipeWire ships ALSA + Pulse + JACK API shims plus a curated
# LV2 plugin set (Calf, LSP, MDA, ZAM) and easyeffects.
{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../custom_vars.nix;
  cfg  = config.genoc.audio;
in {
  imports = [
    ./pipewire.nix
    ./pulseaudio.nix
  ];

  options.genoc.audio = mkOption {
    type = types.enum [ "none" "pipewire" "pulseaudio" ];
    default = "none";
    description = "Which audio stack to enable.";
  };
}
