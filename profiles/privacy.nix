# Privacy profile: Tor relay + i2pd daemon.
#
# Tor base (client, daemon, ExitPolicy=reject *:*) stays in
# genoc/configuration.nix as always-on. This profile flips the relay
# bit on and enables the i2pd mainline service. Per-machine identity
# (Nickname, ContactInfo) belongs in the machine's custom_machine.nix
# so two machines don't accidentally publish the same relay name.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.privacy;
in {
  options.genoc.profile.privacy = {
    enable = mkEnableOption "privacy profile";

    tor.relay = mkOption {
      type = types.bool;
      default = true;
      description = "Run Tor as a non-exit relay (ExitPolicy still reject *:*).";
    };

    i2p.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Run the i2pd mainline daemon (SAM + HTTP + HTTP proxy).";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.tor.relay {
      services.tor = {
        relay.enable = lib.mkOverride 50 true;
        relay.role   = "relay";
        openFirewall = true;
        settings = {
          MaxAdvertisedBandwidth = "10 MB";
          BandWidthRate          = "5 MB";
          BandwidthBurst         = "10 MB";
        };
      };
    })

    (mkIf cfg.i2p.enable {
      services.i2pd = {
        enable = true;
        port   = 45678;
        proto = {
          sam.enable       = true;
          http.enable      = true;
          httpProxy.enable = true;
        };
      };

      networking.firewall = {
        allowedTCPPorts = [ 45678 ];
        allowedUDPPorts = [ 45678 ];
      };
    })
  ]);
}
