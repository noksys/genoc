{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    maestral            # Open-source Dropbox client for macOS and Linux
    maestral-gui        # GUI for Maestral
    rclone              # Command line program to manage files on cloud storage
    nextcloud-client    # Desktop client for Nextcloud
    megasync            # Easy automated syncing between your computers and your MEGA cloud drive
  ];
}
