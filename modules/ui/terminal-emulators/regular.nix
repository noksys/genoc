{ pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  environment.systemPackages = with pkgs; [
    kitty # Feature-rich GPU terminal
  ];
}
