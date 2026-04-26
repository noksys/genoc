{ pkgs }:

with pkgs; [
  aspell             # spell checker engine
  aspellDicts.en     # aspell English dict
  aspellDicts.pt_BR  # aspell PT-BR dict
  featherpad        # lightweight Qt text editor
  gnome-tweaks      # extra GNOME settings (works under KDE for some toggles)
  hunspell          # alternative spell checker (used by libreoffice/firefox)
  ispell            # legacy spell checker (some scripts still expect it)
  neovim            # Vim fork, modern plugin runtime
  vim               # original Vi IMproved
  # vscode lives in the dev profile (genoc/profiles/dev.nix, tasks.editors-gui)
  #texlive.scheme-full  # full TeX Live (huge; commented — pull on demand)
]
