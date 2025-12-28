{ pkgs, ... }:

{
  imports = [ ./regular.nix ];

  environment.systemPackages = with pkgs; [
    discord # Discord client
    dino    # XMPP/Jabber client (Dino)
  ];
}
