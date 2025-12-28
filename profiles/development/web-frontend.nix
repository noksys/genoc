{ ... }:

{
  imports = [
    ../../modules/languages/web/full.nix # Node, Deno, Bun, Yarn
    ../../modules/dev-domains/web-frontend.nix
  ];
}
