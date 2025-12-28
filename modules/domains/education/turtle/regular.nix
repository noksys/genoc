{ pkgs, ... }:

{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    xorg.xlogo # Classic X11 Logo demo
  ];
}
