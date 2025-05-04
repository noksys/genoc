{ pkgs }:

with pkgs; [
  (texlive.withPackages (ps: [
    ps.scheme-full
    ps.wrapfig
    ps.wrapfig2
    poppler_utils
    img2pdf
    python311Packages.img2pdf
    qpdf
  ]))
  okular
]
