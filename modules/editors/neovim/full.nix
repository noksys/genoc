{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    # Dependencies for popular Nvim plugins (Telescope, Treesitter, etc.)
    ripgrep               # Line-oriented search tool (better grep)
    fd                    # Simple, fast and user-friendly alternative to find
    tree-sitter           # Parser generator tool and an incremental parsing library
    gcc                   # Required for compiling Treesitter parsers
    xclip                 # Clipboard support
    wl-clipboard          # Wayland clipboard support
    nodejs                # Required for CoC or some LSPs
  ];
}
