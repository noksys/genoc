{ pkgs, ... }:

{
  imports = [
    ../../modules/domains/finance/personal.nix
    ../../modules/domains/office/regular.nix # Spreadsheets
  ];
}
