{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tailwindcss          # A utility-first CSS framework for rapid UI development
    nodePackages.sass    # Syntactically Awesome Style Sheets
    nodePackages.less    # Leaner CSS
  ];
}
