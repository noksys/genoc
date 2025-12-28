{ pkgs, ... }:

{
  programs.firejail.enable = true;

  environment.systemPackages = with pkgs; [
    firejail # Sandboxing tool for desktop apps
  ];
}
