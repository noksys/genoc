{ pkgs, ... }:

{
  imports = [
    ../../modules/languages/web/full.nix # Node, Deno, Bun, Yarn
  ];

  environment.systemPackages = with pkgs; [
    # API Testing
    postman
    insomnia
    
    # Browsers for dev
    google-chrome
    firefox-devedition-bin
  ];
}
