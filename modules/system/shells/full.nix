{ pkgs, ... }:

{
  imports = [
    ./regular.nix
  ];

  environment.systemPackages = with pkgs; [
    nushell # Modern structured data shell
  ];
}
