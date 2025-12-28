{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = [
    (pkgs.writeTextFile {
      name = "steam.desktop";
      destination = "/share/applications/steam.desktop";
      text = ''
        [Desktop Entry]
        Name=Steam (X11)
        Comment=Application for managing and playing games on Steam
        Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam %U
        Icon=steam
        Terminal=false
        Type=Application
        Categories=Network;FileTransfer;Game;
        MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
        PrefersNonDefaultGPU=true
        X-KDE-RunOnDiscreteGpu=true
      '';
    })
  ];
}
