# Developer profile: IDEs, compilers, debuggers, language toolchains, DB
# clients, container runtimes. Everything that turns this machine into a
# software-engineering workstation.
#
# Today this is one big bucket. If a `minimal` flavor (headless / no GUI)
# becomes useful later, split here without changing callers.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.dev;
  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { };
  gitsh = import ../dev/gitsh.nix { inherit pkgs; };
in {
  options.genoc.profile.dev = {
    enable = mkEnableOption "developer profile";
  };

  config = mkIf cfg.enable {
    # Docker engine (daemon). data-root override stays in custom_machine.nix.
    virtualisation.docker.enable = true;

    # Git default branch.
    programs.git = {
      enable = true;
      config.init.defaultBranch = "main";
    };

    # vscode + qtwebkit/openssl1.1 are flagged unfree/insecure; allowlist them.
    nixpkgs.config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];
      permittedInsecurePackages = [
        "openssl-1.1.1u"
        "qtwebkit-5.212.0-alpha4"
      ];
    };

    environment.systemPackages = with pkgs; [
      # ── Editors / IDEs ────────────────────────────────────────────────────
      code-cursor                    # Cursor IDE (VSCode fork with built-in AI)
      emacs
      vscode
      drawio                         # diagram editor (used inside Emacs workflows)

      # vscode helpers (Wayland/X11 window control)
      wmctrl
      xorg.xprop

      # Emacs build deps (libvterm + Doom prerequisites)
      cmake
      libtool
      libvterm
      gsettings-desktop-schemas
      glib

      # ── Compilers / debuggers / binary inspection ─────────────────────────
      gcc                            # GNU C/C++ compiler
      gdb                            # GNU debugger
      gdbgui                         # browser-based GDB frontend
      gnum4                          # GNU m4 macro processor
      gnumake                        # GNU make
      pkg-config                     # build-time dependency lookup helper
      elfutils                       # readelf / eu-* binary inspection
      hexedit                        # ncurses hex editor
      ltrace                         # trace library calls
      strace                         # trace system calls
      rr                             # record-replay debugger
      valgrind                       # memory debugger / profiler
      binwalk                        # firmware analysis / extraction

      # ── Language toolchains ───────────────────────────────────────────────
      cargo                          # Rust package manager (also via fenix below)
      fenix.complete.toolchain       # Rust nightly toolchain (rustup-style)
      go                             # Go toolchain
      go-tools                       # godoc / goimports / etc.
      golangci-lint                  # Go linter aggregator
      gopls                          # Go LSP server
      gotestsum                      # human-friendly `go test` runner
      govulncheck                    # Go vulnerability scanner
      air                            # live reload for Go apps
      delve                          # Go debugger
      jdk                            # OpenJDK
      maven                          # Java build tool
      jekyll                         # Ruby static-site generator
      ruby                           # MRI Ruby
      rubyPackages.dotenv            # .env loader
      rubyPackages.jekyll-theme-midnight
      bundix                         # Ruby Bundler ↔ Nix integration
      bundler                        # Ruby Bundler (gem dependency manager)
      lua                            # Lua interpreter
      perl                           # Perl 5
      python3                        # default Python 3
      python3Packages.cbor
      python3Packages.certbot-dns-route53
      python3Packages.gpgme
      python3Packages.pip
      python3Packages.pip-tools
      python3Packages.playwright
      python3Packages.uv
      uv                             # uv (top-level CLI)
      nodejs_20                      # Node.js 20 LTS
      deno                           # secure JS/TS runtime
      typescript                     # TypeScript compiler (tsc)
      racket                         # Racket Scheme dialect
      guile                          # GNU Scheme implementation
      chez                           # Cisco Chez Scheme (R6RS+R7RS)
      chicken                        # practical Scheme (compiles to C)
      asdf-vm                        # multi-language version manager
      tree-sitter                    # parser generator (Neovim plugin dep)

      # ── LSP / formatters / linters ────────────────────────────────────────
      nil                            # Nix LSP
      nixpkgs-fmt                    # Nix formatter
      shellcheck                     # shell script linter
      shfmt                          # shell formatter

      # ── Cloud / serverless CLIs ───────────────────────────────────────────
      awscli2                        # AWS CLI v2
      azure-cli                      # Azure CLI
      azure-functions-core-tools     # Azure Functions local dev runtime

      # ── Databases / query tools ───────────────────────────────────────────
      dbeaver-bin                    # universal SQL/NoSQL GUI client
      pgadmin4                       # Postgres admin GUI
      pgcli                          # Postgres CLI with autocomplete
      postgresql_16                  # PostgreSQL engine + client tools

      # ── Containers / orchestration ────────────────────────────────────────
      docker
      docker-compose
      docker-buildx
      lazydocker
      podman
      podman-compose
      distrobox
      dive

      # ── Git tooling ───────────────────────────────────────────────────────
      git                            # Git VCS
      gh                             # GitHub CLI
      git-annex                      # large file content management on git
      git-crypt                      # transparent file encryption in git
      git-filter-repo                # history rewrite (replaces filter-branch)
      git-lfs                        # large file storage extension
      gitsh.git-sh                   # custom build of vlad2/git-sh
      tig                            # ncurses TUI for Git

      # ── CLI productivity / file utils ─────────────────────────────────────
      bat                            # cat with syntax highlighting
      eza                            # modern ls replacement
      fd                             # user-friendly find
      file                           # MIME / file format identification
      tldr                           # simplified man pages
      lnav                           # log file navigator (TUI)
      angle-grinder                  # streaming aggregator for log lines
      mermaid-cli                    # Mermaid diagrams CLI renderer

      # ── Test / automation / project planning ──────────────────────────────
      playwright-test
      taskjuggler                    # project planning DSL + reports
      ganttproject-bin               # Gantt chart project planner
      meld                           # GUI diff/merge tool

      # ── Other build / interop ─────────────────────────────────────────────
      protobuf                       # Protocol Buffers compiler
      trunk                          # Rust WASM web build tool
      libsForQt5.qgpgme              # legacy Qt5 GPGME bindings (some plugins want it)
      systemd                        # systemd userspace tools
      scrcpy                         # mirror/control Android over USB

      # ── Nerd Fonts (used by Emacs config and terminals) ───────────────────
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      noto-fonts-color-emoji
    ];
  };
}
