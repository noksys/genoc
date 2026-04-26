# Browsers profile: every web browser the user might reach for. Yes,
# this is a lot — different sites/workflows behave better in different
# engines. Always-on by default.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.browsers;
in {
  options.genoc.profile.browsers = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brave                # privacy-leaning Chromium fork
      chromium             # vanilla Chromium
      firefox              # Mozilla Firefox
      google-chrome        # Google Chrome
      kdePackages.falkon   # KDE web browser (Qt WebEngine)
      librewolf            # privacy-focused Firefox fork
      mullvad-browser      # Mullvad's hardened Firefox build
      qutebrowser          # keyboard-driven Qt browser
      tor-browser          # Tor Browser bundle
      vivaldi              # Vivaldi browser
    ];
  };
}
