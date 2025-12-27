{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    weechat
    irssi
    hexchat
    znc           # IRC Bouncer
  ];
}
