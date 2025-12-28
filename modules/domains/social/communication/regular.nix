{ pkgs, ... }:

{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    element-desktop # Matrix client
    slack           # Slack client
    mumble          # Low-latency voice chat
    gajim           # XMPP/Jabber client
  ];
}
