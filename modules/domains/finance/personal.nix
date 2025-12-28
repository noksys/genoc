{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnucash     # Personal finance manager
    homebank    # Personal accounting
    gnumeric    # Lightweight spreadsheet
    kmymoney    # KDE finance manager
  ];
}
