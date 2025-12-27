# tlp.nix
{ config, lib, pkgs, ... }:
{
  # Avoid conflicts with KDE's power-profiles-daemon: we use TLP only.
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      # Governors + EPP (intel_pstate/HWP):
      # On AC: keep things quiet and efficient; HWP balances perf vs. noise.
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";

      # On battery: prioritize battery life.
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Turbo (Boost):
      CPU_BOOST_ON_AC = "1";  # allow boost on AC
      CPU_BOOST_ON_BAT = "0"; # disable boost on battery

      # HWP Dynamic Boost (Intel-only):
      CPU_HWP_DYN_BOOST_ON_AC = "1";
      CPU_HWP_DYN_BOOST_ON_BAT = "0";

      # Performance ceilings/floors (% of nominal, intel_pstate):
      # Note: intel_pstate typically clamps min to ~15% anyway.
      CPU_MIN_PERF_ON_AC = "15";
      CPU_MAX_PERF_ON_AC = "100";
      CPU_MIN_PERF_ON_BAT = "15"; # set to 15 to match common clamp
      CPU_MAX_PERF_ON_BAT = "30";

      # Platform profile (may be ignored on Legion if not exposed via ACPI):
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Optional: also cap absolute frequency on battery so `cpupower` shows the lower range.
      # (Not required for efficiency; purely for visibility/consistency.)
      # CPU_SCALING_MIN_FREQ_ON_BAT = "800000";   # 0.8 GHz
      # CPU_SCALING_MAX_FREQ_ON_BAT = "2200000";  # ~2.2 GHz
    };
  };
}
