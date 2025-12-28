{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc     # GNU Compiler Collection
    gnumake # Build automation tool
    binutils # Linker, assembler, and binary tools
  ];
}
