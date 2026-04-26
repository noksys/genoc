# Office profile: LibreOffice, plain-text accounting (hledger/ledger),
# gnucash, calibre, PDF tooling.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.office;
in {
  options.genoc.profile.office = {
    enable = mkEnableOption "office profile (suite + accounting + ebooks)";
  };

  config = mkIf cfg.enable { };
}
