{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    signal-desktop # Signal desktop client
    telegram-desktop # Telegram
  ];
}
