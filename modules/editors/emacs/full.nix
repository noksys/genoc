{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    # Tools for Emacs (Doom/Spacemacs deps)
    fd
    ripgrep
    git
    shellcheck
    editorconfig-core-c
    sqlite                # For org-roam
    zstd                  # For undo-fu-session/vterm
  ];
}
