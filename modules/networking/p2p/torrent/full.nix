{ pkgs, ... }:

{
  imports = [ ./regular.nix ];

  environment.systemPackages = with pkgs; [
    deluge # BitTorrent client (GTK)
    aria2  # CLI downloader with BitTorrent support
  ];
}
