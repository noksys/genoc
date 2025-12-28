{ pkgs, ... }:

{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    0ad        # Historical RTS
    openttd    # Open source transport sim
    wesnoth    # Turn-based tactics
    hedgewars  # Artillery turn-based game
    warzone2100 # RTS
  ];
}
