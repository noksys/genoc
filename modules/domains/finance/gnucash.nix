{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnucash # Personal finance manager
  ];
}
