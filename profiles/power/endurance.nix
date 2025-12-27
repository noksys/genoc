{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ../../policies/power/cpu/eco-ultra.nix
    ../../policies/power/video/nvidia-offload.nix
  ];
}
