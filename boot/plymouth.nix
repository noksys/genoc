{ config, lib, pkgs, ... }:

let
  vars = import ../../custom_vars.nix;
  customPlymouthTheme = pkgs.callPackage ./custom-plymouth-theme.nix { inherit vars; };
in
{
  boot = {
    plymouth = {
      enable = true;
      theme = "${vars.plymouthTheme}";
      themePackages = [ customPlymouthTheme ];
    };
  };

  environment.systemPackages = with pkgs; [
    customPlymouthTheme
    plymouth
  ];
}
