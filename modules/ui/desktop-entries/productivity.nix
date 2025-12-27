{ pkgs, ... }:
let
  vars = import ../../../../custom_vars.nix;
in
{
  # Custom Desktop entries for Productivity and Tools
  environment.systemPackages = [
    (pkgs.writeTextFile {
      name = "kuro.desktop";
      destination = "/share/applications/kuro.desktop";
      text = ''
        [Desktop Entry]
        Categories=Office
        Comment=An unofficial, featureful, open source, community-driven, free Microsoft To-Do app
        Exec=kuro
        GenericName=Microsoft To-Do Client
        Icon=text-x-java
        Name=Kuro
        StartupWMClass=kuro
        Type=Application
        Version=1.4
      '';
    })

    (pkgs.writeTextFile {
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

    (pkgs.writeTextFile {
      name = "gparted.desktop";
      destination = "/share/applications/gparted.desktop";
      text = ''
        [Desktop Entry]
        Name=GParted (X11)
        GenericName=Partition Editor
        Comment=Create, reorganize, and delete partitions
        Exec=sudo bash -c 'xrdb -merge <<< "Xft.dpi: 192" && gparted %f'
        Icon=gparted
        Terminal=false
        Type=Application
        Categories=GNOME;System;Filesystem;
        StartupNotify=true
      '';
    })
  ];
}
