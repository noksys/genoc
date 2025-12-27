{ pkgs, ... }: { environment.systemPackages = [ pkgs.python3Packages.jax pkgs.python3Packages.jaxlib ]; }
