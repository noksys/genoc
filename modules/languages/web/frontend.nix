{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodePackages."@angular/cli"   # CLI for the Angular platform
    nodePackages.create-react-app # Set up a modern web app by running one command
    nodePackages.yo               # The yeoman scaffolding tool
    nodePackages.bower            # A package manager for the web
  ];
}
