{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/office/base.nix
    ../../modules/ui/fonts/ms-compat.nix
  ];

  environment.systemPackages = with pkgs; [
    libreoffice-fresh # Modern office suite
    hunspell # Spell checker
    hunspellDicts.pt_BR # Portuguese dictionary
    pdfgrep # Search in PDFs
    xournalpp # PDF annotation
  ];
}
