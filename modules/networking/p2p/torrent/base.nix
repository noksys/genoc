{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    transmission-gtk # BitTorrent client (GTK)
    transmission-cli # CLI tools (transmission-remote)
  ];
}
