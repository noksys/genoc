{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    megasync # Easy automated syncing between your computers and your MEGA cloud drive
    (writeTextFile {
      name = "mega.desktop";
      destination = "/share/applications/mega.desktop";
      text = ''
        [Desktop Entry]
        Type=Application
        Version=1.0
        GenericName=File Synchronizer
        Name=MEGAsync (X11)
        Comment=Easy automated syncing between your computers and your MEGA cloud drive.
        TryExec=megasync
        Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 megasync
        Icon=mega
        Terminal=false
        Categories=Network;System;
        StartupNotify=false
        X-GNOME-Autostart-Delay=60
      '';
    })
  ];
}
