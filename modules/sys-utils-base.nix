{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # General Utils
    git
    vim
    curl
    wget
    tree
    file
    
    # Network
    inetutils
    dnsutils
  ];
}
