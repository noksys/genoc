{ pkgs }:

with pkgs; [
  claws-mail        # lightweight Gtk2 mail client
  dino              # XMPP/Jabber client (modern Gtk)
  discord           # Discord official client
  #gossip           # nostr client
  maestral          # Dropbox sync (CLI / daemon)
  maestral-gui      # GTK tray for maestral
  mumble            # low-latency voice chat (open-source TS3 alternative)
  # teamspeak3 — deferred: pulls qtwebengine-5.15.19 (Qt5 unmaintained since 2025-04)
  telegram-desktop  # Telegram official Qt client
  vesktop           # third-party Discord client (allows screen-sharing on Linux)
]
