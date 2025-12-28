{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bashInteractive # Standard interactive shell
    zsh             # Popular alternative shell
  ];
}
