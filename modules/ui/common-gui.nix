{ pkgs, ... }:
{
  # Common tools useful for any Graphical Environment
  environment.systemPackages = with pkgs; [
    xclip                 # Command line interface to the X11 clipboard
    wl-clipboard          # Command-line copy/paste utilities for Wayland
    libnotify             # Desktop notification library
    galculator            # GTK Scientific calculator (lightweight fallback)
    pavucontrol           # PulseAudio Volume Control (works with Pipewire)
    networkmanagerapplet  # NetworkManager control applet
    yad                   # Yet Another Dialog (simple GUI prompts)
    appimage-run          # Run AppImages with desktop integration
    wmctrl                # Used for transparency in windows
    xkeyboard_config      # XKB data for libxkbcommon (Wayland/AppImage)
  ];
  
  # Enable fonts
  fonts.fontconfig.enable = true;

  # DConf is required for GSettings (GTK apps)
  programs.dconf.enable = true;

  # Ensure xkbcommon finds XKB data under /nix/store (AppImages expect /usr/share/X11/xkb).
  environment.sessionVariables.XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
}
