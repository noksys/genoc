{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox       # Firefox browser
    chromium      # Chromium browser
    google-chrome # Google Chrome
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
  ];
}
