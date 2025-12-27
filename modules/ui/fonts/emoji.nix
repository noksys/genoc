{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    font-awesome_4
    font-awesome_5
    joypixels
    noto-fonts-color-emoji
    openmoji-color
    symbola
  ];

  fonts.fontconfig.defaultFonts.emoji = [
    "JoyPixels"
    "Noto Color Emoji"
  ];
}
