{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    corefonts # Microsoft core fonts (Arial, Times New Roman, etc.)
    vista-fonts # Calibri, Cambria, Candara, Consolas, Constantia, Corbel
  ];
}
