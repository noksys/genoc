{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    ipafont
    kochi-substitute
    mplus-outline-fonts.githubRelease
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
