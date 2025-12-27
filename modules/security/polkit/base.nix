{ config, lib, pkgs, ... }:
{
  # Polkit is essential for unprivileged processes to speak to privileged ones
  security.polkit.enable = true;
}
