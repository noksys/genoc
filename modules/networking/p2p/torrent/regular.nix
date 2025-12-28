{ pkgs, ... }:

{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    qbittorrent # BitTorrent client (Qt)
  ];
}
