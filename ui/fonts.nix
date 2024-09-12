{ config, lib, pkgs, modulesPath, ... }:

{
  # Fonts, from: https://github.com/JorelAli/nixos/blob/master/configuration.nix
  fonts.fontDir.enable = true;

  fonts = {
    packages = with pkgs; [
      dancing-script
      dejavu_fonts
      dina-font
      fira-code
      fira-code-symbols
      font-awesome_4
      ipafont
      joypixels
      kochi-substitute
      liberation_ttf
      migmix
      mplus-outline-fonts.githubRelease
      #nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      powerline-fonts
      proggyfonts
      siji
      #symbola
    ];

    # Uncomment and customize the default monospace fonts
    # fontconfig.defaultFonts.monospace = [
    #   "Fira Code Medium"                # Set default font as Fira Code Medium
    #   "IPAGothic"                       # Use IPAGothic as fallback font
    #   "Symbola"                         # Use Symbola as fallback font
    #   "dejavu_fonts"
    # ];

    fontconfig.defaultFonts.emoji = [
      # "Noto Color Emoji"  # Uncomment if needed
      "JoyPixels"
    ];
  };
}
