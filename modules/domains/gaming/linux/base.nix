{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    superTux      # Classic platformer
    superTuxKart  # Kart racing game
    pingus        # Lemmings-style puzzle game
    tuxtype       # Typing arcade game (tuxmath not in nixos-25.11)
    tuxpaint      # Drawing/painting for kids
  ];
}
