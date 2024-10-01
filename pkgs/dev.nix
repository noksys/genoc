{ pkgs }:

let
  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { }; # Rust
  gitsh = import ../dev/gitsh.nix { inherit pkgs; };
in
with pkgs; [
  asdf-vm
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
  python3Full
  python312Packages.bitbox02
  python312Packages.cbor
  python312Packages.certbot-dns-route53
  python312Packages.ckcc-protocol
  python312Packages.gpgme
  python312Packages.pip
  python312Packages.pip-tools
  racket
  ruby
  rubyPackages.jekyll-theme-midnight
]
