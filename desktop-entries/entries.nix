# System-wide .desktop entries (custom launchers, GPU/scaling overrides,
# AppImage shortcuts, alternate browser/terminal flavors). Imported as a
# package list from common.nix so the mica-nixos top level stays uncluttered.
{ pkgs, vars }:

with pkgs; [
  (writeTextFile {
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

  (writeTextFile {
    name = "apidog.desktop";
    destination = "/share/applications/apidog.desktop";
    text = ''
      [Desktop Entry]
      Categories=Development
      Comment=API Dog
      Exec=appimage-run ${vars.homeDirectory}/app/Apidog.AppImage
      GenericName=API Dog
      Icon=applications-development
      Name=API Dog
      Type=Application
      Version=1.4
    '';
  })

  (writeTextFile {
    name = "opera-wayland.desktop";
    destination = "/share/applications/opera-wayland.desktop";
    text = ''
      [Desktop Entry]
      Version=1.0
      Name=Opera (Wayland)
      GenericName=Web browser
      Comment=Fast and secure web browser
      TryExec=opera
      Exec=opera --ozone-platform=wayland --enable-features=UseOzonePlatform %U
      Terminal=false
      Icon=opera
      Type=Application
      Categories=Network;WebBrowser;
      MimeType=text/html;text/xml;application/xhtml_xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;application/x-opera-download;
      Actions=new-window;new-private-window;

      [Desktop Action new-window]
      Name=New Window
      Exec=opera --new-window --ozone-platform=wayland --enable-features=UseOzonePlatform
      TargetEnvironment=Unity

      [Desktop Action new-private-window]
      Name=New Private Window
      Exec=opera --incognito --ozone-platform=wayland --enable-features=UseOzonePlatform
      TargetEnvironment=Unity
    '';
  })

  (writeTextFile {
    name = "google-chrome-wayland.desktop";
    destination = "/share/applications/google-chrome-wayland.desktop";
    text = ''
      [Desktop Entry]
      Version=1.0
      Name=Google Chrome (Wayland)
      Exec=google-chrome-stable --ozone-platform=wayland --enable-features=UseOzonePlatform %U
      Terminal=false
      Icon=google-chrome
      Type=Application
      Categories=Network;WebBrowser;
      MimeType=text/html;text/xml;application/xhtml+xml;
      X-GNOME-Autostart-enabled=true
    '';
  })

  (writeTextFile {
    name = "google-chrome-3d.desktop";
    destination = "/share/applications/google-chrome-3d.desktop";
    text = ''
      [Desktop Entry]
      Version=1.0
      Name=Google Chrome (3D)
      Exec=google-chrome-stable --enable-gpu-sandbox --use-gl=desktop %U
      Terminal=false
      Icon=google-chrome
      Type=Application
      Categories=Network;WebBrowser;
      MimeType=text/html;text/xml;application/xhtml+xml;
      X-GNOME-Autostart-enabled=true
    '';
  })

  (writeTextFile {
    name = "google-chrome-x.desktop";
    destination = "/share/applications/google-chrome-x.desktop";
    text = ''
      [Desktop Entry]
      Version=1.0
      Name=Google Chrome (X11)
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 google-chrome-stable --ozone-platform=x11 --enable-features=UseOzonePlatform %U
      Terminal=false
      Icon=google-chrome
      Type=Application
      Categories=Network;WebBrowser;
      MimeType=text/html;text/xml;application/xhtml+xml;
      X-GNOME-Autostart-enabled=true
    '';
  })

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

  (writeTextFile {
    name = "electrum.desktop";
    destination = "/share/applications/electrum.desktop";
    text = ''
      [Desktop Entry]
      Name=Electrum
      Comment=Electrum Bitcoin Wallet
      Exec=${vars.homeDirectory}/app/electrum/start.sh
      Terminal=false
      Type=Application
      Icon=electrum
      MimeType=x-scheme-handler/elements;
      Categories=Office;Finance;P2P;Network;Qt;
      StartupWMClass=Bitcoin-qt
    '';
  })

  (writeTextFile {
    name = "notesnook.desktop";
    destination = "/share/applications/notesnook.desktop";
    text = ''
      [Desktop Entry]
      Version=1.0
      Name=Notesnook
      Comment=Notes
      Exec=appimage-run ${vars.homeDirectory}/app/notesnook_linux_x86_64.AppImage
      Terminal=false
      Type=Application
      Icon=image-vnd.djvu
      Categories=Office
    '';
  })

  (writeTextFile {
    name = "steam.desktop";
    destination = "/share/applications/steam.desktop";
    text = ''
      [Desktop Entry]
      Name=Steam (X11)
      Comment=Application for managing and playing games on Steam
      Comment[pt_BR]=Aplicativo para jogar e gerenciar jogos no Steam
      Comment[bg]=Приложение за ръководене и пускане на игри в Steam
      Comment[cs]=Aplikace pro spravování a hraní her ve službě Steam
      Comment[da]=Applikation til at håndtere og spille spil på Steam
      Comment[nl]=Applicatie voor het beheer en het spelen van games op Steam
      Comment[fi]=Steamin pelien hallintaan ja pelaamiseen tarkoitettu sovellus
      Comment[fr]=Application de gestion et d'utilisation des jeux sur Steam
      Comment[de]=Anwendung zum Verwalten und Spielen von Spielen auf Steam
      Comment[el]=Εφαρμογή διαχείρισης παιχνιδιών στο Steam
      Comment[hu]=Alkalmazás a Steames játékok futtatásához és kezeléséhez
      Comment[it]=Applicazione per la gestione e l'esecuzione di giochi su Steam
      Comment[ja]=Steam 上でゲームを管理＆プレイするためのアプリケーション
      Comment[ko]=Steam에 있는 게임을 관리하고 플레이할 수 있는 응용 프로그램
      Comment[no]=Program for å administrere og spille spill på Steam
      Comment[pt_PT]=Aplicação para organizar e executar jogos no Steam
      Comment[pl]=Aplikacja do zarządzania i uruchamiania gier na platformie Steam
      Comment[ro]=Aplicație pentru administrarea și jucatul jocurilor pe Steam
      Comment[ru]=Приложение для игр и управления играми в Steam
      Comment[es]=Aplicación para administrar y ejecutar juegos en Steam
      Comment[sv]=Ett program för att hantera samt spela spel på Steam
      Comment[zh_CN]=管理和进行 Steam 游戏的应用程序
      Comment[zh_TW]=管理並執行 Steam 遊戲的應用程式
      Comment[th]=โปรแกรมสำหรับจัดการและเล่นเกมบน Steam
      Comment[tr]=Steam üzerinden oyun oynama ve düzenleme uygulaması
      Comment[uk]=Програма для керування іграми та запуску ігор у Steam
      Comment[vi]=Ứng dụng để quản lý và chơi trò chơi trên Steam
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam %U
      Icon=steam
      Terminal=false
      Type=Application
      Categories=Network;FileTransfer;Game;
      MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
      Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
      PrefersNonDefaultGPU=true
      X-KDE-RunOnDiscreteGpu=true

      [Desktop Action Store]
      Name=Store
      Name[pt_BR]=Loja
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam steam://store

      [Desktop Action Community]
      Name=Community
      Name[pt_BR]=Comunidade
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam steam://url/SteamIDControlPage

      [Desktop Action Library]
      Name=Library
      Name[pt_BR]=Biblioteca
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam steam://open/games

      [Desktop Action Servers]
      Name=Servers
      Name[pt_BR]=Servidores
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam steam://open/servers

      [Desktop Action Screenshots]
      Name=Screenshots
      Name[pt_BR]=Capturas de tela
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam steam://open/screenshots

      [Desktop Action News]
      Name=News
      Name[pt_BR]=Notícias
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam steam://open/news

      [Desktop Action Settings]
      Name=Settings
      Name[pt_BR]=Configurações
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam steam://open/settings

      [Desktop Action BigPicture]
      Name=Big Picture
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam steam://open/bigpicture

      [Desktop Action Friends]
      Name=Friends
      Name[pt_BR]=Amigos
      Exec=GDK_DPI_SCALE=2 QT_SCALE_FACTOR=2 steam steam://open/friends
    '';
  })

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

  (writeTextFile {
    name = "gparted.desktop";
    destination = "/share/applications/gparted.desktop";
    text = ''
      [Desktop Entry]
      Name=GParted (X11)
      GenericName=Partition Editor
      X-GNOME-FullName=GParted Partition Editor
      Comment=Create, reorganize, and delete partitions
      Exec=sudo bash -c 'xrdb -merge <<< "Xft.dpi: 192" && gparted %f'
      Icon=gparted
      Terminal=false
      Type=Application
      Categories=GNOME;System;Filesystem;
      Keywords=Partition;
      StartupNotify=true
    '';
  })

  (writeTextFile {
    name = "org.wezfurlong.wezterm.desktop";
    destination = "/share/applications/org.wezfurlong.wezterm.desktop";
    text = ''
      [Desktop Entry]
      Name=WezTerm
      Comment=Wez's Terminal Emulator
      Exec=wezterm start --cwd .
      TryExec=wezterm
      Icon=org.wezfurlong.wezterm
      Type=Application
      Terminal=false
      Categories=System;TerminalEmulator;Utility;
      PrefersNonDefaultGPU=true
      StartupWMClass=org.wezfurlong.wezterm
      Keywords=shell;prompt;command;commandline;cmd;
    '';
  })

  (writeTextFile {
    name = "org.wezfurlong.wezterm-mangohud.desktop";
    destination = "/share/applications/org.wezfurlong.wezterm-mangohud.desktop";
    text = ''
      [Desktop Entry]
      Name=WezTerm (MangoHud)
      Comment=WezTerm with MangoHud FPS overlay
      Exec=mangohud wezterm start --cwd .
      Icon=org.wezfurlong.wezterm
      Type=Application
      Terminal=false
      Categories=System;TerminalEmulator;Utility;
      PrefersNonDefaultGPU=true
      StartupWMClass=org.wezfurlong.wezterm
      Keywords=shell;prompt;command;commandline;cmd;mangohud;fps;
    '';
  })
]
