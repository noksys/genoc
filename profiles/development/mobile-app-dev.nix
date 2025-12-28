{ ... }:

{
  imports = [
    ../../modules/dev-domains/mobile.nix
    ../../modules/languages/jvm/java-base.nix # Often needed for Android
  ];
}
