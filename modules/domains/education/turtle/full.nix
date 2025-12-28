{ pkgs, ... }:

{
  imports = [ ./regular.nix ];

  environment.systemPackages = with pkgs; [
    scratch # Visual programming for kids
  ];
}
