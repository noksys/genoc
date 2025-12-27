{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    iftop
    iotop
    tmux
    wget
    curl
    rsync
    ncdu
  ];
}
