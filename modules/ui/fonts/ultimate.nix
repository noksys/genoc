{ pkgs, ... }:
{
  imports = [
    ./core.nix
    ./coding.nix
    ./creative.nix
    ./emoji.nix
    ./cjk.nix
    ./ms-compat.nix
  ];

  fonts.packages = with pkgs; [
    # Massive collections
    google-fonts
  ];
}
