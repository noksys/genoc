{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neofetch
    fastfetch
    cmatrix
    pipes-sh
    cbonsai
    htop
    btop
    polybar
    rofi
    picom
    starship
  ];
}
