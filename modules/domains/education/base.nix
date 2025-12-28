{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    anki          # Flashcards
    focuswriter   # Distraction-free writing
    kdePackages.kalgebra   # Graph calculator
    kdePackages.kgeography # Geography trainer
  ];
}
