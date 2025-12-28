{ pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  environment.systemPackages = with pkgs; [
    neofetch  # System info CLI
    fastfetch # Fast system info CLI
    cbonsai   # Terminal bonsai generator
  ];
}
