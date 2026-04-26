# Privacy profile: Tor relay, i2pd, privacy-leaning browsers/tools.
# Machine-specific identity (Tor nickname, i2p outTunnels) stays in
# the machine's custom_machine.nix.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.privacy;
in {
  options.genoc.profile.privacy = {
    enable = mkEnableOption "privacy profile (Tor, i2pd)";
  };

  config = mkIf cfg.enable { };
}
