{ pkgs, ... }:
{
  # Custom Desktop entries for Web Browsers with Wayland and HiDPI fixes
  environment.systemPackages = [
    (pkgs.writeTextFile {
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

    (pkgs.writeTextFile {
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

    (pkgs.writeTextFile {
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

    (pkgs.writeTextFile {
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
  ];
}
