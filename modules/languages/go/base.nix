{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go # The Go programming language
  ];
}
