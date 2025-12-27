{ pkgs, ... }:

{
  imports = [
    ../../modules/dev-domains/embedded.nix
    ../../modules/languages/c-cpp/embedded.nix
  ];
}
