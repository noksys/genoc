{ pkgs }:

let
  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { }; # Rust
  gitsh = import ../dev/gitsh.nix { inherit pkgs; };
in
with pkgs; [
  #nodejs_22
  angle-grinder
  asdf-vm
  awscli2
  azure-cli
  azure-functions-core-tools
  bundix
  bundler
  cargo
  deno
  fenix.complete.toolchain
  ganttproject-bin
  gcc
  git
  git-annex
  git-crypt
  git-filter-repo
  gitAndTools.gitFull
  gitsh.git-sh
  gnum4
  gnumake
  go
  go-tools
  golangci-lint
  jdk23
  jekyll
  libsForQt5.qgpgme
  lnav
  mermaid-cli
  nodejs_20
  perl
  playwright-test
  protobuf
  python312Packages.bitbox02
  python312Packages.cbor
  python312Packages.certbot-dns-route53
  python312Packages.ckcc-protocol
  python312Packages.gpgme
  python312Packages.pip
  python312Packages.pip-tools
  python312Packages.playwright
  python312Packages.uv
  python3Full
  racket
  ruby
  rubyPackages.dotenv
  rubyPackages.jekyll-theme-midnight
  scrcpy
  taskjuggler
  typescript
  uv
]
