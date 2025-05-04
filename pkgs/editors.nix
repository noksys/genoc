{ pkgs }:

with pkgs; [
  aspell
  aspellDicts.en
  aspellDicts.pt_BR
  emacs
  emacs-gtk
  emacsPackages.emacs
  featherpad
  gnome-tweaks
  hunspell
  ispell
  neovim
  sublime
  vim
  vscode
  texlive.combined.scheme-full
]
