{ ... }:

{
  imports = [
    ../../modules/domains/crypto/bitcoin.nix
    ../../modules/domains/crypto/elements.nix
    ../../policies/networking/firewall/open-p2p-crypto.nix
  ];
}
