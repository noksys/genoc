{ pkgs, ... }:

{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    xlogo # Classic X11 Logo demo
  ];
}
