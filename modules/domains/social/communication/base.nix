{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tdesktop       # Telegram Desktop
    signal-desktop # Signal Private Messenger
  ];
}
