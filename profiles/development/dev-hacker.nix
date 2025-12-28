{ ... }:

{
  imports = [
    ../../modules/editors/neovim/full.nix
    ../../modules/editors/emacs/full.nix
    ../../modules/dev-domains/git.nix # Git CLI, git-sh, tig
    ../../modules/dev-domains/dev-debug/full.nix
    ../../modules/dev-domains/dev-hacker.nix
    ../../modules/languages/c-cpp/os-dev.nix # Low level stuff
  ];
}
