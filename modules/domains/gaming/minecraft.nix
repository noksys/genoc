{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    minecraft     # Minecraft launcher
    prismlauncher # Open source launcher
    minetest      # Open source voxel game engine
  ];
  
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
