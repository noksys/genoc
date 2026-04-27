# Security aggregator. Imports every security module so their options
# (genoc.security.<name>.enable) are visible everywhere; each module
# gates its own config via mkIf, so this is cheap.
{ ... }:
{
  imports = [
    ./tpm2.nix
    ./sddm-u2f.nix
  ];
}
