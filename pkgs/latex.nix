{ pkgs }:

with pkgs; [
  enscript                       # text → PostScript pretty-printer
  img2pdf                        # raw images → PDF without re-encoding
  kdePackages.okular             # KDE document viewer (PDF/EPUB/CHM/etc.)
  mupdf                          # lightweight PDF viewer
  ocrmypdf                       # OCR layer onto scanned PDFs
  pandoc                         # universal document converter
  pdfgrep                        # grep over PDF text
  pdftk                          # PDF toolkit (split/merge/rotate)
  poppler-utils                  # pdfinfo / pdftotext / pdftoppm
  python311Packages.img2pdf      # img2pdf as a Python module
  qpdf                           # PDF transformation/inspection
  tectonic                       # modernized LaTeX engine (XeTeX-based, self-contained)
  typst                          # modern alternative to LaTeX (fast, sane syntax)
  unscii                         # bitmap fonts useful for ASCII art / docs
  #texlive.scheme-full           # full TeX Live distribution (huge; commented)
]
