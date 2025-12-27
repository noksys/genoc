{ pkgs, ... }:

let
  vars = import ../../../../custom_vars.nix;
in
{
  virtualisation.docker.enable = true;
  
  users.users.${vars.mainUser}.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker-compose # Multi-container orchestration tool
  ];
}
