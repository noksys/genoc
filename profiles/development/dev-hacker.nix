{ pkgs, ... }:

{
  imports = [
    ../../modules/editors/neovim/full.nix
    ../../modules/editors/emacs/doom.nix
    ../../modules/dev-domains/git.nix # Git CLI, git-sh, tig
    ../../modules/dev-domains/os-dev.nix # Low level stuff
  ];

  environment.systemPackages = with pkgs; [
    # Terminal Multiplexers
    tmux
    zellij
    
    # Analysis
    strace
    ltrace
    binwalk
    hexedit
    ripgrep
    fd
    bat
    eza
  ];
}
