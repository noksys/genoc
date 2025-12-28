{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    weechat  # IRC TUI client
    irssi    # IRC TUI client
    hexchat  # IRC GUI client
    znc      # IRC bouncer
  ];
}
