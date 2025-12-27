{ pkgs, ... }: { imports = [ ./base.nix ]; services.xserver.videoDrivers = [ "amdgpu" ]; }
