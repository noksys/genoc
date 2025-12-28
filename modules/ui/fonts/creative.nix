{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    dancing-script
    google-fonts
    libre-baskerville
    libre-bodoni
    libre-caslon
    montserrat
    open-sans
    oswald
    playfair-display
    raleway
  ];
}
