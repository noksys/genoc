# Battery aggregator. Imports every battery/power module so their options
# (genoc.battery.<name>.enable) are visible everywhere; each module gates
# its own config via mkIf.
{ ... }:
{
  imports = [
    ./tlp.nix
    ./refresh-smart.nix
  ];
}
