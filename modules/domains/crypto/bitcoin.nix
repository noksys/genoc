{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitcoind-knots
    bitcoin-knots
    (writeTextFile {
      name = "bitcoin-qt.desktop";
      destination = "/share/applications/bitcoin-qt.desktop";
      text = ''
        [Desktop Entry]
        Name=Bitcoin Knots
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

  services.tor.relay.onionServices = {
    bitcoin = {
      version = 3;
      map = [{
        port = 8333;
        target = { addr = "127.0.0.1"; port = 8333; };
      }];
    };
  };
}
