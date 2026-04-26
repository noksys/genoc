# Crypto node profile: Bitcoin Core, Liquid/Elements, hardware-wallet tooling.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.crypto-node;
in {
  options.genoc.profile.crypto-node = {
    enable = mkEnableOption "crypto node profile (bitcoin, elements, wallets)";
  };

  config = mkIf cfg.enable { };
}
