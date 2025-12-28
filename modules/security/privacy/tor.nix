{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tor         # The Tor anonymity network daemon
    tor-browser # Privacy-focused web browser
  ];
}
