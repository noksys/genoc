{ pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  environment.systemPackages = with pkgs; [
    fish # Friendly interactive shell
  ];
}
