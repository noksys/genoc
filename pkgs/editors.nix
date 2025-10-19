{ pkgs }:

with pkgs; [
  aspell
  aspellDicts.en
  aspellDicts.pt_BR
  (emacs.override { withPgtk = true; })
  featherpad
  gnome-tweaks
  hunspell
  ispell
  neovim
  sublime
  vim
  vscode
  #texlive.scheme-full

  # Doom dependencies
  ripgrep
  fd
  git
  gcc
  gnumake

  noto-fonts-emoji
]
