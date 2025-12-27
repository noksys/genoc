{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    autopsy
    binwalk
    sleuthkit
    ddrescue
    testdisk
    volatility3
  ];
}
