{ pkgs }:

with pkgs; [
  cbonsai     # Terminal bonsai generator
  cmatrix     # Terminal Matrix effect
  fastfetch   # Fast system info CLI (modern neofetch)
  fortune
  neofetch    # System info CLI (unmaintained but stable)
  pipes-rs    # Terminal pipes animation
  polybar     # Status bar (kept here even on Plasma — useful inside nested WMs)
  rofi        # App launcher
]
