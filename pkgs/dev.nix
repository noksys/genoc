{ pkgs }:

let
  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { };
  gitsh = import ../dev/gitsh.nix { inherit pkgs; };
in
with pkgs; [
  # python3Packages.bitbox02     # insecure (commented)
  # python3Packages.ckcc-protocol # insecure (commented)
  #nodejs_22                     # commented; nodejs_20 is the active version below

  air                            # live reload for Go apps
  angle-grinder                  # streaming aggregator for log lines (CLI)
  asdf-vm                        # multi-language version manager
  awscli2                        # AWS CLI v2
  azure-cli                      # Azure CLI
  azure-functions-core-tools     # Azure Functions local dev runtime
  bat                            # cat with syntax highlighting
  binwalk                        # firmware analysis / extraction
  bundix                         # Ruby Bundler ↔ Nix integration
  bundler                        # Ruby Bundler (gem dependency manager)
  cargo                          # Rust package manager (also via fenix below)
  chez                           # Cisco Chez Scheme (Apache 2.0 since 2017)
  chicken                        # practical Scheme system (compiles to C)
  code-cursor                    # Cursor IDE (VSCode fork with built-in AI)
  dbeaver-bin                    # universal SQL/NoSQL GUI client
  delve                          # Go debugger
  deno                           # secure JS/TS runtime
  elfutils                       # readelf / eu-* binary inspection
  eza                            # modern ls replacement
  fd                             # user-friendly find
  fenix.complete.toolchain       # Rust nightly toolchain (rustup-style)
  file                           # MIME / file format identification
  ganttproject-bin               # Gantt chart project planner
  gcc                            # GNU C/C++ compiler
  gdb                            # GNU debugger
  gdbgui                         # browser-based GDB frontend
  gh                             # GitHub CLI
  git                            # Git VCS
  git-annex                      # large file content management on git
  git-crypt                      # transparent file encryption in git
  git-filter-repo                # history rewrite (replaces git filter-branch)
  git-lfs                        # large file storage extension
  gitsh.git-sh                   # custom build of vlad2/git-sh (Bash with git aliases)
  gnum4                          # GNU m4 macro processor
  gnumake                        # GNU make
  go                             # Go toolchain
  go-tools                       # godoc / goimports / etc.
  golangci-lint                  # Go linter aggregator
  gopls                          # Go LSP server
  gotestsum                      # human-friendly `go test` runner
  govulncheck                    # Go vulnerability scanner
  guile                          # GNU Scheme implementation
  hexedit                        # ncurses hex editor
  jdk                            # OpenJDK
  jekyll                         # Ruby static-site generator
  libsForQt5.qgpgme              # Qt5 GPGME bindings (legacy; some plugins still want it)
  lnav                           # log file navigator (TUI)
  ltrace                         # trace library calls
  lua                            # Lua interpreter
  maven                          # Java build tool
  meld                           # GUI diff/merge tool
  mermaid-cli                    # Mermaid diagrams CLI renderer
  nil                            # Nix LSP
  nixpkgs-fmt                    # Nix formatter
  nodejs_20                      # Node.js 20 LTS
  perl                           # Perl 5
  pgadmin4                       # Postgres admin GUI
  pgcli                          # Postgres CLI with autocomplete
  pkg-config                     # build-time dependency lookup helper
  playwright-test                # Playwright test runner
  postgresql_16                  # PostgreSQL engine + client tools
  protobuf                       # Protocol Buffers compiler
  python3                        # default Python 3
  python3Packages.cbor           # CBOR codec lib
  python3Packages.certbot-dns-route53  # certbot Route53 DNS plugin
  python3Packages.gpgme          # GPGME Python bindings
  python3Packages.pip            # pip
  python3Packages.pip-tools      # pip-compile / pip-sync
  python3Packages.playwright     # Playwright Python lib
  python3Packages.uv             # uv (fast pip/pyenv replacement) Python lib
  racket                         # Racket Scheme dialect
  rr                             # record-replay debugger
  ruby                           # MRI Ruby
  rubyPackages.dotenv            # .env loader
  rubyPackages.jekyll-theme-midnight  # Jekyll theme
  scrcpy                         # mirror/control Android over USB
  shellcheck                     # shell script linter
  shfmt                          # shell formatter
  strace                         # trace system calls
  systemd                        # systemd userspace tools
  taskjuggler                    # project planning DSL + reports
  tig                            # ncurses TUI for Git
  tldr                           # simplified man pages
  tree-sitter                    # parser generator (Neovim plugin dep)
  trunk                          # Rust WASM web build tool
  typescript                     # TypeScript compiler (tsc)
  uv                             # uv (top-level CLI)
  valgrind                       # memory debugger / profiler
]
