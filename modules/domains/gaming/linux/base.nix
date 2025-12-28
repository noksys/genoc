{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    supertux      # Classic platformer
    supertuxkart  # Kart racing game
    pingus        # Lemmings-style puzzle game
    tuxmath       # Math arcade game
    tuxpaint      # Drawing/painting for kids
  ];
}
