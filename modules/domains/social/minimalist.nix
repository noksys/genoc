{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    signal-desktop # Signal desktop client
    tdesktop # Telegram
  ];
}
