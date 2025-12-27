{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    anki          # Flashcards
    focuswriter   # Distraction-free writing
    kalgebra      # Graph calculator
    kgeography    # Geography trainer
  ];
}
