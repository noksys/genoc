{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop   # Interactive process viewer
    iftop  # Network traffic monitor
    iotop  # Disk I/O monitor
    tmux   # Terminal multiplexer
    wget   # File downloader
    curl   # HTTP client
    rsync  # File sync tool
    ncdu   # Disk usage analyzer
  ];
}
