{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    # Tools for Emacs (Doom/Spacemacs deps)
    fd                  # Fast file finder
    ripgrep             # Fast search
    git                 # Version control
    shellcheck          # Shell linting
    editorconfig-core-c # EditorConfig CLI
    sqlite                # For org-roam
    zstd                  # For undo-fu-session/vterm
  ];
}
