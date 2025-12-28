{ pkgs, ... }:

{
  imports = [
    # Base Headless Utils
    ../../modules/sys-utils/headless.nix
    ../../modules/sys-utils/cli-web-tools.nix

    # Core Development Domains (GUI-free subsets)
    ../../modules/virtualization/containers/base.nix
    ../../modules/dev-domains/dev-debug/full.nix
    ../../modules/dev-domains/git.nix
    ../../modules/dev-domains/dev-newbie.nix
    
    # Terminal-friendly Editors
    ../../modules/editors/emacs/base.nix
    ../../modules/editors/neovim/full.nix

    # AI Modules
    ../../modules/ai/tools/shell-gpt.nix
  ];
}