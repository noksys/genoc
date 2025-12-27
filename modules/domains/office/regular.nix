{ pkgs, ... }:
{
  imports = [ ./base.nix ];
  
  environment.systemPackages = with pkgs; [
    libreoffice-qt        # Comprehensive, professional-quality productivity suite (QT variant)
    hunspell              # Spell checker
    hunspellDicts.en_US   # English dictionary
    hunspellDicts.pt_BR   # Portuguese dictionary
  ];
}
