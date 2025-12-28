{ pkgs, ... }:
# This module uses the Fenix overlay for easy access to Nightly/Beta toolchains.
# Note: This requires fetching a tarball, which might be slower on initial build.
let
  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { };
in
{
  environment.systemPackages = [
    fenix.complete.toolchain # Rust nightly toolchain (fenix)
  ];
}
