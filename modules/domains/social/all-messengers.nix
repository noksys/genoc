{ pkgs, ... }:

{
  imports = [ ./minimalist.nix ];

  environment.systemPackages = with pkgs; [
    discord
    slack
    element-desktop
    whatsapp-for-linux
    zoom-us
    teams-for-linux
    skypeforlinux
    viber
    weechat
  ];
}
