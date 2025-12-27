{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/multimedia/streaming.nix
    ../../modules/hardware/audio/pipewire.nix
  ];
}
