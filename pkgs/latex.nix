{ pkgs }:

with pkgs; [
  img2pdf
  okular
  pandoc
  pdfgrep
  poppler_utils
  python311Packages.img2pdf
  qpdf
  tectonic
  #texlive.scheme-full
]
