{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nano           # Simple terminal editor
    gedit          # Simple GUI text editor (GNOME)
    kate           # KDE text editor
    sublime4       # Sublime Text editor
    git-cola       # GUI for Git
    github-desktop # GitHub Desktop client
    tldr           # Simplified man pages
  ];
}
