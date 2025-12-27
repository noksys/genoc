{ pkgs, ... }:
{
  imports = [ ./regular.nix ];
  
  environment.systemPackages = with pkgs; [
    # --- LaTeX & Advanced ---
    texlive.combined.scheme-full # A TeX distribution with all packages (Huge!)
    pandoc                # Universal markup converter
    pdftk                 # A simple tool for doing everyday things with PDF documents
    ghostscript           # PostScript and PDF language interpreter and previewer
    calibre               # E-book management application
  ];
}
