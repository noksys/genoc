{ config, lib, pkgs, ... }:
{
  # Base NVIDIA Configuration (Drivers + Tools)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    open = lib.mkDefault false;       # Use proprietary kernel modules by default
    nvidiaSettings = lib.mkDefault true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia      # Nvtop for Nvidia
    nvidia-container-toolkit  # Build and run containers leveraging NVIDIA GPUs
    nvidia-system-monitor-qt  # Task Manager for Nvidia
  ];
}
