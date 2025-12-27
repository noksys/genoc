{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vscode                # Visual Studio Code
  ];
}
