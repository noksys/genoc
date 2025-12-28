{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    masterpdfeditor # PDF editor
    pdftk           # PDF toolkit
    okular        # Excellent PDF reader with annotation support
    ghostscript     # PostScript/PDF engine
  ];
}
