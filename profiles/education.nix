# Education profile: kturtle and other learning tools.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.education;
in {
  options.genoc.profile.education = {
    enable = mkEnableOption "education profile (kturtle, etc.)";
  };

  config = mkIf cfg.enable { };
}
