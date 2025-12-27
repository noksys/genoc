{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    darktable     # RAW developer
    rawtherapee   # RAW developer alternative
    digikam       # Photo management
    hugin         # Panorama stitcher
    displaycal    # Monitor calibration
    exiftool
  ];
}
