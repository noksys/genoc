{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neofetch  # System info CLI
    fastfetch # Fast system info CLI
    cmatrix   # Terminal Matrix effect
    pipes-sh  # Terminal pipes animation
    cbonsai   # Terminal bonsai generator
    htop      # Interactive process viewer
    btop      # Resource monitor
    polybar   # Status bar
    rofi      # App launcher
    picom     # Compositor for X11
    starship  # Shell prompt
  ];
}
