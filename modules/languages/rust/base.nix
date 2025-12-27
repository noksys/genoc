{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cargo  # Downloads your Rust project's dependencies and builds your project
    rustc  # The Rust compiler
    gcc    # GNU Compiler Collection (often needed for linking C deps)
  ];
}
