# Developer profile: IDEs, compilers, debuggers, language toolchains.
#
# flavor = "minimal" → core toolchains + LSPs only
# flavor = "full"    → everything (DB clients, project tools, GUI debuggers, etc.)
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.dev;
in {
  options.genoc.profile.dev = {
    enable = mkEnableOption "developer profile";
    flavor = mkOption {
      type = types.enum [ "minimal" "full" ];
      default = "full";
      description = "minimal = core toolchains + LSPs; full = + GUIs and DB clients.";
    };
  };

  config = mkIf cfg.enable { };
}
