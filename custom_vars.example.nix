let
  mainUser = "lazyuser";
in
{
  bootDevice = "/dev/lazydev"; # can be /dev/sda e.g.
  defaultConsoleKeyMap = "us"; # br-abnt2 or run cat $(nix-build --no-out-link '<nixpkgs>' -A xkeyboard_config)/etc/X11/xkb/rules/base.lst to get possible values.
  homeDirectory = "/home/${mainUser}";
  hostName = "lazyhost";
  installationNixOSVersion = "24.05"; # what version did you use to make the first install?
  mainUser = mainUser;
  timeZone = "America/Sao_Paulo";
  userFullName = "Lazy Guy";
}
