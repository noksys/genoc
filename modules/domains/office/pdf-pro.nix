{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    masterpdfeditor
    pdftk
    okular        # Excellent PDF reader with annotation support
    ghostscript
  ];
}
