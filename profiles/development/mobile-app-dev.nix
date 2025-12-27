{ pkgs, ... }:

{
  imports = [
    ../../modules/dev-domains/mobile.nix
    ../../modules/languages/jvm/java.nix # Often needed for Android
  ];
}
