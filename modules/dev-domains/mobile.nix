{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Android
    android-studio
    android-tools # adb, fastboot
    scrcpy        # Screen mirroring
    
    # Cross-platform
    flutter
    dart
  ];
  
  programs.adb.enable = true;
  users.users.${(import ../../custom_vars.nix).mainUser}.extraGroups = ["adbusers"];
}
