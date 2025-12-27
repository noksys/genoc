{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    docker-compose        # Define and run multi-container applications with Docker
    lazydocker            # The lazier way to manage everything docker
    podman                # A program for managing pods, containers and container images
    podman-compose        # An implementation of docker-compose with podman backend
    distrobox             # Use any linux distribution inside your terminal
    dive                  # A tool for exploring each layer in a docker image
  ];
}