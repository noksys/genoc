{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32b.psf.gz";
  };

#   specialisation = {
#     tty = {
#       inheritParentConfig = true;
#       configuration = {
#         # Override to disable X server and desktop managers
#         services.xserver.enable = lib.mkOverride 101 false;
#         services.xserver.desktopManager.plasma5.enable = lib.mkOverride 101 false;
#         services.xserver.desktopManager.gnome.enable = lib.mkOverride 101 false;
#         services.xserver.desktopManager.lxqt.enable = lib.mkOverride 101 false;
#
#         # Override display manager sub-options (do not override 'enable' as it is not defined)
#         services.xserver.displayManager.lightdm.enable = lib.mkOverride 101 false;
#         services.xserver.displayManager.gdm.enable = lib.mkOverride 101 false;
#       };
#     };
#   };

  users.users.${vars.mainUser} = lib.mkMerge [{
    packages = with pkgs; [
      fbida
      terminus_font
      kbd
      nerdfonts
      tamsyn
      psftools
      bdfresize
      bdf2psf
      fontforge
      otf2bdf
      w3m
      links2
      lynx
    ];
  }];
}
