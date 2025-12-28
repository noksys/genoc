{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tdesktop        # Telegram Desktop
    discord         # All-in-one voice and text chat for gamers
    element-desktop # Matrix client
    signal-desktop  # Signal Private Messenger
    slack           # Slack client
    mumble          # Low-latency voice chat
    gajim           # XMPP/Jabber client
    dino            # XMPP/Jabber client (Dino)
  ];
}
