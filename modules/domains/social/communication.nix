{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tdesktop              # Telegram Desktop
    discord               # All-in-one voice and text chat for gamers
    element-desktop       # A feature-rich client for Matrix.org
    signal-desktop        # Signal Private Messenger
    slack                 # Desktop client for Slack
  ];
}
