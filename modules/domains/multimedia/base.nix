{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # --- Viewers ---
    vlc                   # Cross-platform media player and streaming server
    mpv                   # General-purpose media player, fork of mplayer2 and MPlayer
    feh                   # A light-weight image viewer
    zathura               # A highly customizable and functional document viewer
  ];
}
