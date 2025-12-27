{ config, lib, pkgs, ... }:
{
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  
  # Disable WiFi powersave for maximum stability and low latency
  networking.networkmanager.wifi.powersave = lib.mkDefault false;
}
