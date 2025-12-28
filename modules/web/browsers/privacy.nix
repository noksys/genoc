{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tor-browser     # Tor Browser
    mullvad-browser # Mullvad Browser
    librewolf       # Privacy-focused Firefox fork
  ];
}
