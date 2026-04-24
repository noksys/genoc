{ pkgs, ... }:

let
  vars = import ../../../../custom_vars.nix;
in
{
  virtualisation.docker.enable = true;
  
  users.users.${vars.mainUser}.extraGroups = [ "docker" ];

  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose # Multi-container orchestration tool
    docker-buildx
    nvidia-container-toolkit
  ];
}
