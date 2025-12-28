{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    google-fonts
  ];
}
