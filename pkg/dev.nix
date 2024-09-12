{ pkgs }:

let
  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { }; # Rust
  gitsh = import ./gitsh.nix { inherit pkgs; };
in
with pkgs; [
  awscli2
  azure-cli
  azure-functions-core-tools
  bundix
  bundler
  cargo
  fenix.complete.toolchain
  gcc
  git
  git-annex
  git-crypt
  gitsh.git-sh
  gitAndTools.gitFull
  gnum4
  gnumake
  go
  go-tools
  golangci-lint
  jekyll
  libsForQt5.qgpgme
  nodejs_20
  perl
  protobuf
  python3
  python310Packages.pip
  python310Packages.pip-tools
  python311Packages.bitbox02
  python311Packages.cbor
  python311Packages.certbot-dns-route53
  racket
  ruby
  rubyPackages.jekyll-theme-midnight
]
