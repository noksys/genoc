{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32b.psf.gz";
  };

  specialisation = {
    text.configuration = {
      systemd.services.display-manager.enable = false;
    };
  };

  users.users.${vars.mainUser} = lib.mkMerge [{
    packages = with pkgs; [
      aalib
      bb
      bdf2psf
      bdfresize
      browsh
      fbida
      fontforge
      kbd
      libcaca
      links2
      lynx
      mplayer

      # Nerd Fonts (replaces the old 'nerdfonts' meta-package)
      # Add or remove fonts below as you prefer.
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.hack
      nerd-fonts.caskaydia-cove
      nerd-fonts.victor-mono
      nerd-fonts.sauce-code-pro

      otf2bdf
      psftools
      tamsyn
      tartube-yt-dlp
      terminus_font
      w3m
      yt-dlp
    ];
  }];
}
