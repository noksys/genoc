{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    masterpdfeditor # PDF editor
    pdftk           # PDF toolkit
    kdePackages.okular # Excellent PDF reader with annotation support
    ghostscript     # PostScript/PDF engine
  ];
}
