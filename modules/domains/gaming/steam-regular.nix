{ pkgs, ... }:

{
  imports = [ ./steam-basic.nix ];

  environment.systemPackages = with pkgs; [
    mangohud    # Vulkan/OpenGL overlay for FPS and metrics
    protonup-qt # Proton/GE manager for Steam
  ];
}
