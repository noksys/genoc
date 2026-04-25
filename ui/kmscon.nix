{ pkgs, ... }:

{
  # kmscon: KMS-based virtual terminal with hwRender + nice font.
  # Mirrors the xkb layout from genoc/configuration.nix (br,us with alt-intl).
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      font-name=FiraCode Nerd Font Mono
      font-size=22
      sb-size=1000000
      xkb-layout=br,us
      xkb-variant=,alt-intl
      xkb-options=grp:shifts_toggle
    '';
  };
}
