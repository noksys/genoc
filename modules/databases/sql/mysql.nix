{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mariadb               # Open source drop-in replacement for MySQL
    mycli                 # CLI for MySQL with auto-completion and syntax highlighting
  ];
}
