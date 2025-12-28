{ pkgs, ... }:

{
  imports = [
    ./regular.nix
  ];

  environment.systemPackages = with pkgs; [
    foot       # Minimal Wayland-native terminal
    wezterm    # Modern GPU terminal with Lua config
    tilix      # Tiling terminal emulator
    terminator # Multi-pane terminal emulator
  ];
}
