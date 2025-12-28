{ pkgs, ... }: {
  fonts.fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ]; # Standard high-quality color emojis
  environment.systemPackages = [ pkgs.noto-fonts-color-emoji ];
}
