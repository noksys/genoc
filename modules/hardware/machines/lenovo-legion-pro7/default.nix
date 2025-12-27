{ config, lib, pkgs, ... }:

{
  imports = [
    # Import community hardware quirks
    <nixos-hardware/lenovo/legion/16irx8h>
    
    # New Modular Hardware Definitions
    ../../modules/hardware/video/nvidia/drivers.nix
    ../../modules/hardware/audio/pipewire-pro.nix
    ../../modules/hardware/storage/ssd-optimizations.nix
    
    # Default Power Profile
    ../../policies/power/cpu/balance.nix
  ];

  # ---- Bootloader -----------------------------------------------------------
  boot.loader.efi.canTouchEfiVariables = true;
  
  # ---- Kernel & Hardware Specifics ------------------------------------------
  boot.kernelModules = [ "kvm-intel" ];
  
  # Audio Patch
  hardware.firmware = [
    (pkgs.runCommand "legion-audio-patch" {} ''
      mkdir -p $out/lib/firmware
      cp ${./audio-patch/legion-alc287.patch} $out/lib/firmware/legion-alc287.patch
    '')
  ];
  
  boot.extraModprobeConfig = ''
    options snd-hda-intel patch=legion-alc287.patch
  '';

  boot.blacklistedKernelModules = [ "snd_soc_avs" ];

  # ---- Networking -----------------------------------------------------------
  networking.useDHCP = lib.mkDefault true;
}