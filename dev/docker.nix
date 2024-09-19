{ config, lib, pkgs, modulesPath, ... }:

{
  virtualisation.docker.enable = true;

  #virtualisation.docker.storageDriver = "btrfs";
  #virtualisation.docker.extraOptions = "--data-root=/home/docker";

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      docker
      ])
  ];
}
