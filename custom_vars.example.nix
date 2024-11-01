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
  plymouthTheme = "rings";
  timeZone = "America/Sao_Paulo";
  torControlPasswordHash = "16:97DE2B9B1F6198A46076DB9B879BF5291CC71B5CE6F27FE5CF4746C99C"; # tor --hash-password "xpto"
  userFullName = "Lazy Guy";
}
