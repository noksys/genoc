{ pkgs }:

with pkgs; [
  cbonsai     # Terminal bonsai generator
  cmatrix     # Terminal Matrix effect
  fastfetch   # Fast system info CLI (modern neofetch)
  fortune
  pipes-rs    # Terminal pipes animation
  polybar     # Status bar (kept here even on Plasma — useful inside nested WMs)
]
