{ pkgs }:

with pkgs; [
  claws-mail
  dino
  discord
  #gossip
  mumble
  # teamspeak3 — deferred: pulls qtwebengine-5.15.19 (Qt5 unmaintained since 2025-04)
  telegram-desktop
  vesktop # allow screen sharing on Discord
]
