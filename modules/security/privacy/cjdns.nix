{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cjdns # Provides cjdroute
  ];
}
