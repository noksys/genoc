{ pkgs, ... }:

{
  imports = [ ./regular.nix ];

  environment.systemPackages = with pkgs; [
    # scratch not available in nixos-25.11
  ];
}
