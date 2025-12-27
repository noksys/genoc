{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brave
    vivaldi
    opera
    nyxt
    qutebrowser
    falkon
    epiphany
  ];
}
