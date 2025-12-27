{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tor-browser           # Privacy-focused browser
    i2pd                  # I2P Daemon (Invisible Internet Project)
    onioncircuits         # GTK application to display Tor circuits and streams
    # freenet             # (Check availability in nixpkgs)
  ];
}
