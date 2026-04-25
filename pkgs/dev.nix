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
  bat                    # cat with syntax highlighting
  binwalk                # firmware analysis
  cargo
  code-cursor
  dbeaver-bin
  dbgate                 # multi-DB GUI client
  delve                  # Go debugger
  deno
  elfutils               # readelf / eu-*
  eza                    # modern ls
  fd                     # user-friendly find
  file                   # MIME / format identification
  fenix.complete.toolchain
  ganttproject-bin
  gcc
  gdb                    # GNU debugger
  gdbgui                 # browser-based GDB frontend
  gedit                  # simple GTK text editor
  gh
  git
  git-annex
  git-cola               # GUI for Git
  git-crypt
  git-filter-repo
  git-lfs                # large file support
  github-desktop
  gitsh.git-sh
  gnum4
  gnumake
  go
  go-tools
  golangci-lint
  gopls                  # Go LSP
  gotestsum              # human-friendly `go test` runner
  govulncheck
  guile                  # GNU Scheme implementation
  chicken                # practical Scheme system (compiles to C)
  chez                   # Cisco Chez Scheme (Apache 2.0 since 2017)
  hexedit
  jdk
  jekyll
  libsForQt5.qgpgme
  lnav
  ltrace                 # trace library calls
  maven
  meld
  mermaid-cli
  nil                    # Nix LSP
  nixpkgs-fmt            # Nix formatter
  nodejs_20
  perl
  pgadmin4
  pgcli                  # Postgres CLI with autocompletion
  pkg-config
  postgresql_16          # PostgreSQL engine + client
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
  rr                     # record-replay debugger
  scrcpy
  shellcheck             # shell script linter
  shfmt                  # shell formatter
  strace
  systemd
  taskjuggler
  tig
  tldr                   # simplified man pages
  tree-sitter            # parser generator (used by Neovim plugins)
  trunk
  typescript
  uv
  valgrind               # memory debugger / profiler
  lua
  air                    # live reload for Go apps
]
