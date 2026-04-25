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
      google-fonts              # huge family for design work (creative profile)
      joypixels
      liberation_ttf
      nerd-fonts.fira-code      # system-wide so kmscon (TTY) can render it
      noto-fonts
      noto-fonts-cjk-sans       # CJK fallback for misc apps; cheap, keep
      noto-fonts-color-emoji
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

    fontconfig = {
      antialias = true;
      hinting.enable = true;
      hinting.style = "full";
      subpixel.rgba = "rgb";
      subpixel.lcdfilter = "default";

      # defaultFonts.emoji is set in mantis-legion-pro-7/common.nix to
      # "Noto Color Emoji" — that wins by being loaded later, so the line
      # here was dead config (and contradicting JoyPixels). Removed.
      # joypixels package stays in fonts.packages above, available if
      # opted-in elsewhere.
    };
  };
}
