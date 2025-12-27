{ pkgs, ... }:
let
  vars = import ../../../../custom_vars.nix;
in
{
  # Custom Desktop entries for Crypto Wallets and Nodes
  environment.systemPackages = [
    (pkgs.writeTextFile {
      name = "elements-qt.desktop";
      destination = "/share/applications/elements-qt.desktop";
      text = ''
        [Desktop Entry]
        Name=Elements-Qt (Liquid Network)
        Comment=Connect to the Liquid P2P Network
        Exec=elements-qt %u
        Terminal=false
        Type=Application
        Icon=atom
        MimeType=x-scheme-handler/elements;
        Categories=Office;Finance;P2P;Network;Qt;
        StartupWMClass=Elements-qt
      '';
    })

    (pkgs.writeTextFile {
      name = "bitcoin-qt.desktop";
      destination = "/share/applications/bitcoin-qt.desktop";
      text = ''
        [Desktop Entry]
        Name=Bitcoin-Qt
        Comment=Connect to the Bitcoin P2P Network
        Exec=bitcoin-qt %u
        Terminal=false
        Type=Application
        Icon=bitcoin
        MimeType=x-scheme-handler/elements;
        Categories=Office;Finance;P2P;Network;Qt;
        StartupWMClass=Bitcoin-qt
      '';
    })
  ];
}
