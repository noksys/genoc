{ ... }:

{
  imports = [
    ../../modules/dev-domains/dev-newbie.nix
    ../../modules/editors/vscode/full.nix
    ../../modules/ui/common-gui.nix # Includes GUI tools usually
  ];
}
