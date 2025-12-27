{ config, pkgs, ... }:

{
  imports = [
    ./service.nix
    ./web-proxy.nix
    ./darknet.nix
  ];
}
