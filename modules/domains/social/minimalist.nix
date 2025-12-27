{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    signal-desktop
    tdesktop # Telegram
  ];
}
