{ pkgs, ... }:

{
  imports = [
    ./dev-hacker.nix # Assumes a God uses Nvim/Emacs
    ./backend-go.nix
    ./backend-rust.nix
    ./web-frontend.nix
    ../../modules/dev-domains/cloud-devops/k8s-full.nix
  ];
}
