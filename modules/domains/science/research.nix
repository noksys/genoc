{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zotero # Reference manager
    jabref # BibTeX manager
  ];
}
