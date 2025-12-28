{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    elementsd
    elements
    (writeTextFile {
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
  ];
}

