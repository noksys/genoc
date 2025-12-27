{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    corefonts # Microsoft core fonts (Arial, Times New Roman, etc.)
    vistafonts # Calibri, Cambria, Candara, Consolas, Constantia, Corbel
  ];
}
