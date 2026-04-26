# Fun profile: terminal toys, status bars, neofetch-likes. Trivial
# but enjoyable. Off by default; flip on workstations.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.fun;
in {
  options.genoc.profile.fun = {
    enable = mkEnableOption "fun profile (terminal toys + status bar)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cbonsai     # Terminal bonsai generator
      cmatrix     # Terminal Matrix effect
      fastfetch   # Fast system info CLI (modern neofetch)
      fortune
      pipes-rs    # Terminal pipes animation
      polybar     # Status bar (kept here even on Plasma)
    ];
  };
}
