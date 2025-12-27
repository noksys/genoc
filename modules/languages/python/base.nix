{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    python3           # The Python programming language
    python3Packages.pip # The PyPA recommended tool for installing Python packages
    python3Packages.uv  # An extremely fast Python package installer and resolver written in Rust
  ];
}
