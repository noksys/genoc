{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # Don't forget to run:
    # sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
    # sudo nix-channel --update

    <nixos-hardware/lenovo/legion/16irx8h>
    ./baremetal.nix
  ];

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';

  boot.blacklistedKernelModules = [ "snd_soc_avs" ];

  # Graphics settings
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.prime = {
    offload.enable = lib.mkForce false;
    sync.enable = lib.mkForce true;
  };

  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __NV_PRIME_RENDER_OFFLOAD = "0";
    GBM_BACKEND = "nvidia-drm";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      nvtopPackages.intel
      nv-codec-headers
      nvidia-container-toolkit
      nvidia-optical-flow-sdk
      nvidia-system-monitor-qt
      nvidia-texture-tools
      nvidia-vaapi-driver
      nvtopPackages.nvidia
    ])
  ];
}
