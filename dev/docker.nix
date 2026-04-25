{ config, lib, pkgs, modulesPath, ... }:

{
  virtualisation.docker.enable = true;

  #virtualisation.docker.storageDriver = "btrfs";
  #virtualisation.docker.extraOptions = "--data-root=/home/docker";

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      docker
      docker-compose      # multi-container orchestration
      docker-buildx       # multi-arch builds
      lazydocker          # TUI manager for docker
      podman              # rootless alternative engine
      podman-compose      # docker-compose-compatible CLI for podman
      distrobox           # run other distros inside containers
      dive                # explore image layers
      ])
  ];
}
