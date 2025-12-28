{ pkgs, ... }:
{
  imports = [
    ./megasync.nix
  ];

  environment.systemPackages = with pkgs; [
    maestral            # Open-source Dropbox client for macOS and Linux
    maestral-gui        # GUI for Maestral
    rclone              # Command line program to manage files on cloud storage
    nextcloud-client    # Desktop client for Nextcloud
  ];
}
