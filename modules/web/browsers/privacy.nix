{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tor-browser
    mullvad-browser
    librewolf
  ];
}
