{ pkgs, ... }:

{
  imports = [ ./minimalist.nix ];

  environment.systemPackages = with pkgs; [
    discord           # Discord client
    slack             # Slack client
    element-desktop   # Matrix client
    mumble            # Low-latency voice chat
    gajim             # XMPP/Jabber client
    dino              # XMPP/Jabber client (Dino)
    whatsapp-for-linux # WhatsApp desktop client
    zoom-us           # Zoom client
    teams-for-linux   # Microsoft Teams client
    skypeforlinux     # Skype client
    viber             # Viber client
    weechat           # IRC TUI client
  ];
}
