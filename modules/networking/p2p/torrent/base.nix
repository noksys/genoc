{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    transmission_4-gtk # BitTorrent client (GTK)
    transmission-cli # CLI tools (transmission-remote)
  ];
}
