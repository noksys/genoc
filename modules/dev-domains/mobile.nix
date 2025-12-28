{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Android
    android-studio # Android IDE
    android-tools # adb, fastboot
    scrcpy        # Screen mirroring
    
    # Cross-platform
    flutter       # Flutter SDK
    dart          # Dart SDK
  ];
  
  programs.adb.enable = true;
  users.users.${(import ../../custom_vars.nix).mainUser}.extraGroups = ["adbusers"];
}
