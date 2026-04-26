# genoc/profiles/default.nix
#
# Aggregator. Importing this directory wires up every profile module so that
# `genoc.profile.<name>.enable = true` becomes available in the machine
# configuration. Each module is a no-op until enabled (mkIf cfg.enable),
# so listing them all here costs nothing at evaluation time.
{ ... }:
{
  imports = [
    ./dev.nix
    ./gaming.nix
    ./crypto-node.nix
    ./privacy.nix
    ./ricing.nix
    ./media-creator.nix
    ./office.nix
    ./education.nix
    ./forensics.nix
    ./self-host.nix
  ];
}
