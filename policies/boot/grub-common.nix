{ config, lib, pkgs, ... }:

let
  vars = import ../../../custom_vars.nix;
  grubFont = pkgs.runCommand "grub-font-36" {} ''
    mkdir -p $out
    ${pkgs.grub2}/bin/grub-mkfont -s 36 -o $out/DejaVuSansMono36.pf2 \
      ${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf
  '';
in
{
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    splashImage = ./theme/bg.png;
    font = "${grubFont}/DejaVuSansMono36.pf2";
    extraConfig = ''
      set color_normal=black/white
      set color_highlight=white/black
    '';
  };

  boot.loader.timeout = 60;
}
