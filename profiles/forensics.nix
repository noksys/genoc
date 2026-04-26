# Forensics profile: firejail, age, vault, sandboxing tools.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.forensics;
in {
  options.genoc.profile.forensics = {
    enable = mkEnableOption "forensics profile (sandboxing, secrets tooling)";
  };

  config = mkIf cfg.enable { };
}
