# Developer profile.
#
# Two orthogonal knobs:
#
#   genoc.profile.dev.langs.<lang> = "min" | "full"
#       Per-language toolchain depth. "min" = compiler/runtime + LSP;
#       "full" = + debuggers, framework helpers, advanced lint/test tooling,
#       niche extras.  Languages absent from the attrset get nothing.
#
#   genoc.profile.dev.tasks.<task> = "min" | "full"
#       Cross-cutting workflow buckets that span languages (databases,
#       cloud CLIs, container runtimes, GUI editors, planning…).
#       Tasks absent from the attrset get nothing.
#
# Overlap between langs and tasks is fine: both can pull `gcc` (cpp lang +
# systems-style task) and the package list just unions — Nix references the
# same store path once. Only scalar options conflict, and we don't set any.
#
# Always-on when `enable = true`: language-agnostic core (git, gh, neovim,
# LSPs that have nothing to do with a specific language, file utils,
# asdf-vm meta version manager). Vim/neovim are NOT here — they live in
# pkgs/editors.nix as universal system editors regardless of profile.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.dev;

  # "min" depth fires for both min+full; "full" only fires for full.
  lev      = lang: cfg.langs.${lang} or null;
  hasLang  = lang: lev lang == "min" || lev lang == "full";
  fullLang = lang: lev lang == "full";

  tlev     = task: cfg.tasks.${task} or null;
  hasTask  = task: tlev task == "min" || tlev task == "full";
  fullTask = task: tlev task == "full";

  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { };
  gitsh = import ../dev/gitsh.nix { inherit pkgs; };
in {
  options.genoc.profile.dev = {
    enable = mkEnableOption "developer profile";

    langs = mkOption {
      type = types.attrsOf (types.enum [ "min" "full" ]);
      default = {};
      example = { go = "full"; js = "min"; haskell = "min"; };
      description = ''
        Per-language toolchain depth. Absent languages install nothing.
        Recognized keys: go js java python ruby rust scheme lua perl cpp
        haskell prolog.
      '';
    };

    tasks = mkOption {
      type = types.attrsOf (types.enum [ "min" "full" ]);
      default = {};
      example = { cloud = "min"; data = "full"; containers = "full"; ai = "min"; };
      description = ''
        Cross-cutting workflow buckets. Absent tasks install nothing.
        Recognized keys: cloud data containers editors-gui planning ai.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # ── Always-on core (when enable=true) ────────────────────────────────────
    {
      programs.git = {
        enable = true;
        config.init.defaultBranch = "main";
      };

      # Allowlist for unfree/insecure packages this profile may install
      # (across all tasks/langs). Setting it once at the always-on level
      # avoids fragmenting the predicate across mkIf branches.
      nixpkgs.config = {
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "vscode"
          "code-cursor"
          "obsidian"
          "claude-code"
          "codex"
          "gemini-cli"
          "lmstudio"
        ];
        permittedInsecurePackages = [
          "openssl-1.1.1u"
          "qtwebkit-5.212.0-alpha4"
        ];
      };

      environment.systemPackages = with pkgs; [
        git                            # Git VCS
        gh                             # GitHub CLI
        git-annex                      # large file content management on git
        git-crypt                      # transparent file encryption in git
        git-filter-repo                # history rewrite (replaces filter-branch)
        git-lfs                        # large file storage extension
        gitsh.git-sh                   # custom build of vlad2/git-sh
        tig                            # ncurses TUI for Git

        bat                            # cat with syntax highlighting
        eza                            # modern ls replacement
        fd                             # user-friendly find
        file                           # MIME / file format identification
        tldr                           # simplified man pages
        lnav                           # log file navigator (TUI)
        angle-grinder                  # streaming aggregator for log lines
        mermaid-cli                    # Mermaid diagrams CLI renderer

        nil                            # Nix LSP
        nixpkgs-fmt                    # Nix formatter
        shellcheck                     # shell script linter
        shfmt                          # shell formatter
        gnumake gnum4 pkg-config protobuf tree-sitter

        asdf-vm                        # multi-language version manager (meta)

        scrcpy                         # mirror/control Android over USB
        systemd                        # systemd userspace tools
        libsForQt5.qgpgme              # legacy Qt5 GPGME bindings (some plugins want it)
      ];
    }

    # ── Languages ────────────────────────────────────────────────────────────

    # Go
    (mkIf (hasLang "go") {
      environment.systemPackages = with pkgs; [ go go-tools gopls ];
    })
    (mkIf (fullLang "go") {
      environment.systemPackages = with pkgs; [
        delve golangci-lint gotestsum govulncheck air
      ];
    })

    # JavaScript / TypeScript
    (mkIf (hasLang "js") {
      environment.systemPackages = with pkgs; [ nodejs_20 typescript ];
    })
    (mkIf (fullLang "js") {
      environment.systemPackages = with pkgs; [ deno bun playwright-test ];
    })

    # Java — bare JDK in min; build tools live in full.
    (mkIf (hasLang "java") {
      environment.systemPackages = with pkgs; [ jdk ];
    })
    (mkIf (fullLang "java") {
      environment.systemPackages = with pkgs; [ maven ];
    })

    # Python
    (mkIf (hasLang "python") {
      environment.systemPackages = with pkgs; [
        python3 python3Packages.pip uv python3Packages.uv
      ];
    })
    (mkIf (fullLang "python") {
      environment.systemPackages = with pkgs; [
        python3Packages.pip-tools
        python3Packages.cbor
        python3Packages.certbot-dns-route53
        python3Packages.gpgme
        python3Packages.playwright
      ];
    })

    # Ruby
    (mkIf (hasLang "ruby") {
      environment.systemPackages = with pkgs; [ ruby bundler bundix ];
    })
    (mkIf (fullLang "ruby") {
      environment.systemPackages = with pkgs; [
        rubyPackages.dotenv rubyPackages.jekyll-theme-midnight jekyll
      ];
    })

    # Rust — min is a self-contained workstation.
    (mkIf (hasLang "rust") {
      environment.systemPackages = with pkgs; [
        rustc cargo rust-analyzer clippy rustfmt
      ];
    })
    (mkIf (fullLang "rust") {
      environment.systemPackages = with pkgs; [
        fenix.complete.toolchain trunk
      ];
    })

    # Scheme
    (mkIf (hasLang "scheme") {
      environment.systemPackages = with pkgs; [ racket guile ];
    })
    (mkIf (fullLang "scheme") {
      environment.systemPackages = with pkgs; [ chez chicken ];
    })

    # Haskell
    (mkIf (hasLang "haskell") {
      environment.systemPackages = with pkgs; [
        ghc cabal-install haskell-language-server
      ];
    })
    (mkIf (fullLang "haskell") {
      environment.systemPackages = with pkgs; [ stack hlint ];
    })

    # Prolog
    (mkIf (hasLang "prolog") {
      environment.systemPackages = with pkgs; [ swi-prolog ];
    })
    (mkIf (fullLang "prolog") {
      environment.systemPackages = with pkgs; [ gprolog ];
    })

    # Lua
    (mkIf (hasLang "lua") {
      environment.systemPackages = with pkgs; [ lua ];
    })

    # Perl
    (mkIf (hasLang "perl") {
      environment.systemPackages = with pkgs; [ perl ];
    })

    # C / C++ + low-level systems debugging
    (mkIf (hasLang "cpp") {
      environment.systemPackages = with pkgs; [ gcc gdb ];
    })
    (mkIf (fullLang "cpp") {
      environment.systemPackages = with pkgs; [
        gdbgui valgrind ltrace strace rr binwalk hexedit elfutils
      ];
    })

    # ── Tasks ────────────────────────────────────────────────────────────────

    # Cloud CLIs
    (mkIf (hasTask "cloud") {
      environment.systemPackages = with pkgs; [ awscli2 azure-cli ];
    })
    (mkIf (fullTask "cloud") {
      environment.systemPackages = with pkgs; [ azure-functions-core-tools ];
    })

    # Data / databases
    (mkIf (hasTask "data") {
      environment.systemPackages = with pkgs; [ postgresql_16 pgcli ];
    })
    (mkIf (fullTask "data") {
      environment.systemPackages = with pkgs; [ dbeaver-bin pgadmin4 ];
    })

    # Container runtimes — min stays trim, full is the kitchen sink + k8s.
    (mkIf (hasTask "containers") {
      virtualisation.docker.enable = true;
      environment.systemPackages = with pkgs; [ docker docker-compose ];
    })
    (mkIf (fullTask "containers") {
      environment.systemPackages = with pkgs; [
        docker-buildx
        podman podman-compose
        distrobox
        lazydocker dive
        # Kubernetes
        kubectl k9s kubernetes-helm kustomize kind minikube
      ];
    })

    # GUI editors / IDEs.
    # min  = vscode + meld (the indispensable GUI baseline).
    # full = +cursor, +emacs and its build chain, +drawio, +extra coding fonts.
    (mkIf (hasTask "editors-gui") {
      environment.systemPackages = with pkgs; [
        vscode
        wmctrl xorg.xprop                          # vscode helpers
        meld                                       # GUI diff/merge
      ];
    })
    (mkIf (fullTask "editors-gui") {
      environment.systemPackages = with pkgs; [
        code-cursor                                # Cursor IDE (VSCode fork + AI)
        obsidian                                   # markdown notes / second brain
        emacs
        cmake libtool libvterm gsettings-desktop-schemas glib  # emacs/Doom build chain
        nerd-fonts.jetbrains-mono                  # extra coding fonts (fira-code is in fonts.nix)
        nerd-fonts.hack
        drawio                                     # diagram editor
      ];
    })

    # Project planning / task orchestration.
    (mkIf (hasTask "planning") {
      environment.systemPackages = with pkgs; [ taskjuggler ];
    })
    (mkIf (fullTask "planning") {
      environment.systemPackages = with pkgs; [ ganttproject-bin ];
    })

    # AI assistants (CLI agents in min, local LLM stack in full).
    # API keys live in the user's home-manager (per-user secrets); the
    # binaries themselves are system-wide.
    #
    # Caffeine ships in min: long agent runs would otherwise be interrupted
    # by screen blank / suspend. The powersave specialisation in
    # genoc/ui/kde.nix already kills caffeine.service on activation, so
    # there's no battery cost when the user explicitly chooses powersave.
    (mkIf (hasTask "ai") {
      environment.systemPackages = with pkgs; [
        claude-code                                # Anthropic Claude CLI
        codex                                      # OpenAI Codex CLI
        gemini-cli                                 # Google Gemini CLI
        caffeine-ng                                # screen-blank / suspend inhibitor (tray)
      ];

      # NOTE: code-cursor is also pulled by tasks.editors-gui="full" (it's a
      # VSCode fork, primarily an editor). Listing it here too means
      # "ai=min/full also gets Cursor", which matches user mental model
      # of Cursor as an AI-first tool. Nix dedupes by store path, so no cost.
    })

    (mkIf (fullTask "ai") {
      environment.systemPackages = with pkgs; [
        code-cursor                                # Cursor IDE (VSCode fork + AI agent)
      ];

      systemd.user.services.caffeine = {
        description = "Caffeine — inhibit screen blank and suspend (long-running AI agents)";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.caffeine-ng}/bin/caffeine";
          Restart = "on-failure";
        };
      };
    })
    (mkIf (fullTask "ai") {
      environment.systemPackages = with pkgs; [
        llama-cpp                                  # local LLM inference (CPU/GPU)
        lmstudio                                   # GUI for browsing/running local models
      ];
    })
  ]);
}
