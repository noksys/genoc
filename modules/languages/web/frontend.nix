{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodePackages."@angular/cli"   # CLI for the Angular platform
    nodePackages.yo               # The yeoman scaffolding tool
    nodePackages.bower            # A package manager for the web
  ];
}
