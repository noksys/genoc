{ pkgs }:

let
  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { }; # Rust
  gitsh = import ../dev/gitsh.nix { inherit pkgs; };
in
with pkgs; [
  # python3Packages.bitbox02 # insecure
  # python3Packages.ckcc-protocol # insecure
  #nodejs_22
  angle-grinder
  asdf-vm
  awscli2
  azure-cli
  azure-functions-core-tools
  bundix
  bundler
  cargo
  dbeaver-bin
  deno
  fenix.complete.toolchain
  ganttproject-bin
  gcc
  gh
  git
  git-annex
  git-crypt
  git-filter-repo
  gitFull
  gitsh.git-sh
  gnum4
  gnumake
  go
  go-tools
  golangci-lint
  govulncheck
  jdk
  jekyll
  libsForQt5.qgpgme
  lnav
  maven
  meld
  mermaid-cli
  nodejs_20
  perl
  pgadmin4
  pkg-config
  playwright-test
  protobuf
  python3
  python3Packages.cbor
  python3Packages.certbot-dns-route53
  python3Packages.gpgme
  python3Packages.pip
  python3Packages.pip-tools
  python3Packages.playwright
  python3Packages.uv
  racket
  ruby
  rubyPackages.dotenv
  rubyPackages.jekyll-theme-midnight
  scrcpy
  systemd
  taskjuggler
  tig
  trunk
  typescript
  uv
  lua
]
