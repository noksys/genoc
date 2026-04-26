# genoc/profiles/default.nix
#
# Aggregator. Importing this directory wires up every profile module so that
# `genoc.profile.<name>.{enable,…} = …` becomes available in the machine
# configuration. Each module is a no-op until enabled (mkIf cfg.enable),
# so listing them all here costs nothing at evaluation time.
{ ... }:
{
  imports = [
    ./browsers.nix
    ./comm.nix
    ./console-tools.nix
    ./crypto-node.nix
    ./dev.nix
    ./education.nix
    ./forensics.nix
    ./fun.nix
    ./gaming.nix
    ./media-consumer.nix
    ./media-creator.nix
    ./network.nix
    ./office.nix
    ./privacy.nix
    ./ricing.nix
    ./security-tools.nix
    ./self-host.nix
    ./tools.nix
  ];
}
