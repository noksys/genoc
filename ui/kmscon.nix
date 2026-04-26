{ config, lib, pkgs, ... }:

lib.mkIf config.genoc.ui.kmscon.enable {
  # kmscon: KMS-based virtual terminal with hwRender + nice font.
  # Mirrors the xkb layout from genoc/configuration.nix (us,br Intl/ABNT2).
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      font-name=FiraCode Nerd Font Mono
      font-size=22
      sb-size=1000000
      xkb-layout=us,br
      xkb-variant=intl,
      xkb-options=grp:shifts_toggle
    '';
  };
}
