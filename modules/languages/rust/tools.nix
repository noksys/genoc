{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rust-analyzer # Modular compiler frontend for the Rust language (LSP)
    clippy        # A bunch of lints to catch common mistakes and improve your Rust code
    rustfmt       # A tool for formatting Rust code according to style guidelines
    bacon         # Background rust code checker
    evcxr         # Rust REPL
  ];
}
