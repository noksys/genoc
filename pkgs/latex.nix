{ pkgs }:

with pkgs; [
  (texlive.withPackages (ps: [
    ps.scheme-full
    ps.wrapfig
    ps.wrapfig2
  ]))
  okular
]
