{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
  grubFont = pkgs.runCommand "grub-font-36" {} ''
    mkdir -p $out
    ${pkgs.grub2}/bin/grub-mkfont -s 36 -o $out/DejaVuSansMono36.pf2 \
      ${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf
  '';
in
{
  boot.loader.systemd-boot.enable = false;

  boot.loader.grub = {
    enable = true;
    device = "${vars.bootDevice}";
    useOSProber = true;
    configurationLimit = 20;
    splashImage = ./bg.png;
    font = "${grubFont}/DejaVuSansMono36.pf2";
    extraConfig = ''
      set color_highlight=black/white
    '';
  };

  boot.loader.timeout = 60;
}
