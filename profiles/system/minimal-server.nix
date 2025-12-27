{ pkgs, ... }:

{
  imports = [
    ../../modules/sys-utils/headless.nix
  ];
  
  # Ensure no X11
  services.xserver.enable = false;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;
}
