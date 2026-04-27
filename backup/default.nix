# Backup aggregator. Today only tarsnap; structure mirrors the other
# genoc/<area>/default.nix aggregators.
{ ... }:
{
  imports = [
    ./tarsnap.nix
  ];
}
