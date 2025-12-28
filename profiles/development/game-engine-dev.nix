{ ... }:

{
  imports = [
    ../../modules/dev-domains/game-dev.nix
    ../../modules/languages/c-cpp/base.nix # For C# scripting backend
    ../../modules/languages/dot-net/full.nix
  ];
}
