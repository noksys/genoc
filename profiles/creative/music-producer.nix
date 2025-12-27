{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/multimedia/audio-production.nix
    ../../modules/hardware/audio/pipewire-pro.nix # Low latency config
  ];
}
