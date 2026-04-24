{ pkgs, ... }:

{

  imports = [
    ../../modules/languages/lisp-family/scheme.nix
  ];

  # Enable Magic SysRq in safe mode (REISUB without dangerous memory dumps)
  boot.kernel.sysctl."kernel.sysrq" = 244;

  environment.systemPackages = with pkgs; [
    tmux    # Terminal multiplexer
    # zellij  # Modern terminal multiplexer (disabled: requires rust 1.92, nixpkgs has 1.91)
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
