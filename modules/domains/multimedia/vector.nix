{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    inkscape      # Vector editor
    scribus       # Desktop Publishing (Indesign alt)
    fontforge     # Font editor
  ];
}
