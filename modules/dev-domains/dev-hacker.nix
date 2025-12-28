{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux    # Terminal multiplexer
    zellij  # Modern terminal multiplexer
    strace  # Trace system calls
    ltrace  # Trace library calls
    binwalk # Firmware analysis tool
    hexedit # Hex editor for binaries
    ripgrep # Fast recursive search (rg)
    fd      # User-friendly find alternative
    bat     # cat with syntax highlighting
    eza     # Modern ls replacement
  ];
}
