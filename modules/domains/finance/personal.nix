{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnucash
    homebank
    gnumeric    # Lightweight spreadsheet
    kmymoney
  ];
}
