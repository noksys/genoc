{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tor          # The Tor anonymity network daemon
    tor-browser  # Privacy-focused web browser
    onioncircuits # GTK application to display Tor circuits and streams
    torsocks     # Run apps through a Tor SOCKS proxy
  ];
}
