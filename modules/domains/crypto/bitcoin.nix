{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitcoind
    bitcoin
    (writeTextFile {
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
