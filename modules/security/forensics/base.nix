{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    autopsy     # Digital forensics platform
    binwalk     # Firmware analysis
    sleuthkit   # File system forensics
    ddrescue    # Data recovery tool
    testdisk    # Partition recovery
    volatility3 # Memory forensics
  ];
}
