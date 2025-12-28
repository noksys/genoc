{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fortune  # Classic terminal fortune cookies
    htop     # Interactive process viewer
    btop     # Resource monitor
    picom    # Compositor for X11
    starship # Shell prompt
  ];
}
