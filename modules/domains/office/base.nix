{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    evince                # GNOME Document Viewer
    poppler-utils         # PDF rendering library tools (pdfimages, pdfunite...)
    kuro                  # Microsoft TO-DO
  ];
}
