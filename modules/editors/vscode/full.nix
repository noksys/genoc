{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  environment.systemPackages = with pkgs; [
    # Tools often used by VSCode extensions
    nil                   # Nix LSP
    nixpkgs-fmt           # Nix formatter
    shellcheck            # Shell script analysis tool
    shfmt                 # Shell parser, formatter, and interpreter
  ];
}
