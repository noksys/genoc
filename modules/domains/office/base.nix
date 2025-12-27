{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    evince                # GNOME Document Viewer
    poppler_utils         # PDF rendering library tools (pdfimages, pdfunite...)
  ];
}
