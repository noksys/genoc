{ pkgs, ... }:

{
  imports = [
    ../../modules/virtualization/containers/base.nix
    ../../modules/dev-domains/git.nix
    ../../modules/editors/vscode/full.nix
    ../../modules/editors/emacs/base.nix
  ];
}
