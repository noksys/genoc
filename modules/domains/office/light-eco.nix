{ pkgs, ... }:

{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    libreoffice-fresh # Modern office suite (latest features)
    hunspell          # Spell checker
    hunspellDicts.pt_BR # Portuguese dictionary
    pdfgrep           # Search inside PDFs
    xournalpp         # PDF annotation and handwritten notes
  ];
}
