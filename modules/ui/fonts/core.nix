{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    dejavu_fonts
    liberation_ttf
    noto-fonts
    ubuntu-classic
  ];
}
