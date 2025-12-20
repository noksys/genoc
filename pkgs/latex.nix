{ pkgs }:

with pkgs; [
  img2pdf
  kdePackages.okular
  pandoc
  pdfgrep
  poppler-utils
  python311Packages.img2pdf
  qpdf
  unscii
  tectonic
  #texlive.scheme-full
  pdftk
  enscript
  mupdf
  ocrmypdf
]
