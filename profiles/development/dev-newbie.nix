{ pkgs, ... }:

{
  imports = [
    ../../modules/editors/vscode/full.nix
    ../../modules/ui/common-gui.nix # Includes GUI tools usually
  ];

  environment.systemPackages = with pkgs; [
    # Friendly Editors
    nano
    gedit
    kate
    sublime4
    
    # GUI Git
    git-cola
    github-desktop
    
    # Helpers
    tldr # Simpler man pages
  ];
}
