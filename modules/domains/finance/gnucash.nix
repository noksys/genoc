{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnucash
  ];
}
