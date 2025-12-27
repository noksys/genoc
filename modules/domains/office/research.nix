{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jabref                       # Open-source bibliography reference manager
    zotero                       # Personal research assistant
  ];
}
