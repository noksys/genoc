# Developer profile.
#
# Two orthogonal knobs:
#
#   genoc.profile.dev.langs.<lang> = "default" | "full"
#       Per-language toolchain depth. "default" = compiler/runtime + LSP;
#       "full" = + debuggers, framework helpers, advanced lint/test tooling.
#       Languages absent from the attrset get nothing.
#
#   genoc.profile.dev.tasks.<task> = "default" | "full"
#       Cross-cutting workflow buckets that span languages (databases,
#       cloud CLIs, container runtimes, GUI editors, …).
#       Tasks absent from the attrset get nothing.
#
# Overlap between langs and tasks is fine: both can pull `gcc` (cpp lang +
# systems-style task) and the package list just unions — Nix references the
# same store path once. Only scalar options conflict, and we don't set any.
#
# Always-on when `enable = true`: language-agnostic core (git, gh, neovim,
# LSPs that have nothing to do with a specific language, file utils).
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.dev;

  # Helpers: "default" depth fires for both default+full; "full" only fires for full.
  lev      = lang: cfg.langs.${lang} or null;
  isLang   = lang: l: lev lang == l;
  hasLang  = lang: lev lang == "default" || lev lang == "full";
  fullLang = lang: lev lang == "full";

  tlev      = task: cfg.tasks.${task} or null;
  hasTask   = task: tlev task == "default" || tlev task == "full";
  fullTask  = task: tlev task == "full";

  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { };
  gitsh = import ../dev/gitsh.nix { inherit pkgs; };
in {
  options.genoc.profile.dev = {
    enable = mkEnableOption "developer profile";

    langs = mkOption {
      type = types.attrsOf (types.enum [ "default" "full" ]);
      default = {};
      example = { go = "full"; js = "default"; rust = "full"; };
      description = ''
        Per-language toolchain depth. Absent languages install nothing.
        Recognized keys: go js java python ruby rust scheme lua perl cpp.
      '';
    };

    tasks = mkOption {
      type = types.attrsOf (types.enum [ "default" "full" ]);
      default = {};
      example = { cloud = "default"; data = "full"; containers = "full"; };
      description = ''
        Cross-cutting workflow buckets. Absent tasks install nothing.
        Recognized keys: cloud data containers editors-gui automation web.
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
      environment.systemPackages = with pkgs; [ nodejs_20 ];
    })
    (mkIf (fullLang "js") {
      environment.systemPackages = with pkgs; [
        deno typescript playwright-test
      ];
    })

    # Java
    (mkIf (hasLang "java") {
      environment.systemPackages = with pkgs; [ jdk ];
    })
    (mkIf (fullLang "java") {
      environment.systemPackages = with pkgs; [ maven ];
    })

    # Python
    (mkIf (hasLang "python") {
      environment.systemPackages = with pkgs; [
        python3
        python3Packages.pip
        python3Packages.pip-tools
        uv
        python3Packages.uv
      ];
    })
    (mkIf (fullLang "python") {
      environment.systemPackages = with pkgs; [
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

    # Rust
    (mkIf (hasLang "rust") {
      environment.systemPackages = with pkgs; [ cargo ];
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

    # Container runtimes
    (mkIf (hasTask "containers") {
      virtualisation.docker.enable = true;
      environment.systemPackages = with pkgs; [
        docker docker-compose docker-buildx podman podman-compose distrobox
      ];
    })
    (mkIf (fullTask "containers") {
      environment.systemPackages = with pkgs; [ lazydocker dive ];
    })

    # GUI editors / IDEs (vscode, cursor, emacs, project planners, GUI diff)
    (mkIf (hasTask "editors-gui") {
      nixpkgs.config = {
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];
        permittedInsecurePackages = [ "openssl-1.1.1u" "qtwebkit-5.212.0-alpha4" ];
      };
      environment.systemPackages = with pkgs; [
        vscode
        wmctrl xorg.xprop                          # vscode helpers
        emacs cmake libtool libvterm gsettings-desktop-schemas glib  # emacs build deps
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.hack
        noto-fonts-color-emoji
        meld                                       # GUI diff/merge
      ];
    })
    (mkIf (fullTask "editors-gui") {
      environment.systemPackages = with pkgs; [
        code-cursor                                # Cursor IDE (VSCode fork + AI)
        drawio                                     # diagram editor
        ganttproject-bin                           # Gantt planner
      ];
    })

    # Automation / project planning / version managers
    (mkIf (hasTask "automation") {
      environment.systemPackages = with pkgs; [ asdf-vm taskjuggler ];
    })
  ]);
}
