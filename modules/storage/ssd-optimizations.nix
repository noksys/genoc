{ pkgs, ... }:
{
  services.fstrim.enable = true;
  
  # Optional: file system specific tweaks could go here, 
  # but zfs/btrfs modules handle their own specifics usually.
}
