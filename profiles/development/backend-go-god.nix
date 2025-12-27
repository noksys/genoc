{ pkgs, ... }:

{
  imports = [
    ../../modules/languages/go/full.nix
    ../../modules/editors/vscode/full.nix
    ../../modules/editors/emacs/base.nix
    ../../modules/editors/neovim/full.nix
    ../../modules/editors/jetbrains/goland.nix
    ../../modules/databases/sql/postgres.nix
    ../../modules/virtualization/containers/base.nix
    ../../modules/domains/crypto/base.nix
    ../../modules/domains/crypto/elements.nix
  ];

  environment.systemPackages = with pkgs; [
    vim # Legendary text editor
    gnumake # Build tool
    postman # API testing
  ];
}
