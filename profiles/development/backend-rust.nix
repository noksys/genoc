{ ... }:

{
  imports = [
    ../../modules/languages/rust/full.nix
    ../../modules/languages/rust/debug.nix
    ../../modules/languages/c-cpp/base.nix # Often needed for linking
    ../../modules/dev-domains/dev-debug/full.nix
  ];
}
