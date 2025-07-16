{ config, lib, pkgs, ... }:

{
  imports = [
    <nixos-hardware/lenovo/legion/16irx8h>
    ./baremetal.nix
  ];

  hardware.firmware = [
    (pkgs.runCommandNoCC "legion-audio-patch" {} ''
      mkdir -p $out/lib/firmware
      cp ${./legion-alc287.patch} $out/lib/firmware/legion-alc287.patch
    '')
  ];

  boot.extraModprobeConfig = ''
    # options snd-hda-intel model=alc287-yoga9-bass-spk-pin
    options snd-hda-intel patch=legion-alc287.patch
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
    [ pkgs.hyprlock ]

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
