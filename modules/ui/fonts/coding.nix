{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    hack-font
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    powerline-fonts
    proggyfonts
    roboto-mono
    source-code-pro
  ];
}
