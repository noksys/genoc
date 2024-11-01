{ pkgs }:

with pkgs; [
  aspell
  aspellDicts.pt_BR
  aspellDicts.en
  emacs
  emacs-gtk
  emacsPackages.emacs
  featherpad
  gnome.gnome-tweaks
  hunspell
  ispell
  neovim
  vim
  vscode
]
