{ pkgs, ... }:

{
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
