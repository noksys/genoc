{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.kate
    kdePackages.kcalc
    kdePackages.spectacle # Screenshot
    kdePackages.ark       # Archive manager
    kdePackages.okular    # PDF
    
    # Core tools
    kdePackages.kde-cli-tools
    kdePackages.systemsettings
    kdePackages.kio-admin
  ];
}