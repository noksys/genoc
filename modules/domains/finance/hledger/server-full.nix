{ config, pkgs, ... }:

{
  imports = [
    ./service.nix
    ./web-proxy.nix
    ./privacy-networks.nix
  ];
}
