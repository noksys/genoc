{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    postman               # API testing client
    insomnia              # API testing client (lightweight)
    google-chrome         # Web browser for frontend dev
    firefox-devedition-bin # Firefox Developer Edition
  ];
}
