{ config, lib, ... }:
{
  services.power-profiles-daemon.enable = false;

  # ULTRA ECO MODE: Cap CPU frequencies hard.
  services.tlp = {
    enable = true;
    settings = {
      # Keep AC reasonably performant
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      
      # Throttle BAT aggressively
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      CPU_BOOST_ON_BAT = "0";
      CPU_HWP_DYN_BOOST_ON_BAT = "0";
      
      # Cap Performance to 30%
      CPU_MIN_PERF_ON_BAT = "10";
      CPU_MAX_PERF_ON_BAT = "30";
    };
  };
  
  networking.networkmanager.wifi.powersave = lib.mkDefault true;
}
