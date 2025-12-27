{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hledger
    hledger-ui
    hledger-web
  ];
}
