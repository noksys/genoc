{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # General Utils
    git    # Version control system
    vim    # CLI text editor
    curl   # HTTP client
    wget   # File downloader
    tree   # Directory tree viewer
    file   # File type identification
    
    # Network
    inetutils # Basic network utilities (ping, telnet, etc.)
    dnsutils  # DNS lookup tools (dig, nslookup)
  ];
}
