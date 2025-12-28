{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brave       # Brave browser
    vivaldi     # Vivaldi browser
    opera       # Opera browser
    nyxt        # Keyboard-driven browser
    qutebrowser # Keyboard-driven browser
    kdePackages.falkon # KDE browser
    epiphany    # GNOME Web
  ];
}
