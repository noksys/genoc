{ pkgs, ... }:

{
  services.udev.packages = [ pkgs.openrgb ];

  environment.systemPackages = with pkgs; [
    openrgb # RGB lighting control for devices
  ];
}
