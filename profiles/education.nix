# Education profile: learning tools (turtle graphics, etc.).
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.education;
in {
  options.genoc.profile.education = {
    enable = mkEnableOption "education profile";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.kturtle
    ];
  };
}
