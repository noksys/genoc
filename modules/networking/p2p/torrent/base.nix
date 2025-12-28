{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    transmission_4-gtk # BitTorrent client (GTK)
    transmission_4-cli # CLI tools (transmission-remote)
  ];
}
