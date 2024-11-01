{ stdenv, fetchurl, lib, vars }:

stdenv.mkDerivation rec {
  pname = "${vars.plymouthTheme}-custom";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/adi1090x/plymouth-themes/archive/refs/tags/v1.0.tar.gz";
    sha256 = "sha256-jCAa/Mi4UHg3Jg6GifMnPKmuGIkDMxH1W1JEgLceF4I=";
  };

  nixosImage = ./nixos.png;

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  patchPhase = ''
    themeName="${vars.plymouthTheme}"
    themeDir=$(find $PWD -type d -name "$themeName" | head -n 1)
    scriptFile="$themeDir/$themeName.script"

    if [ -d "$themeDir" ]; then
      cp ${nixosImage} "$themeDir/nixos.png"
      echo '
      nixos_image = Image("nixos.png");
      nixos_sprite = Sprite();
      nixos_sprite.SetImage(nixos_image);
      nixos_sprite.SetX(Window.GetX() + (Window.GetWidth() / 2 - nixos_image.GetWidth() / 2));
      nixos_sprite.SetY(Window.GetHeight() - nixos_image.GetHeight() - 50);
      ' >> "$scriptFile"
    else
      echo "Error: The theme directory $themeDir doesn't exist."
      exit 1
    fi
  '';

  installPhase = ''
    mkdir -p $out/share/plymouth/themes
    cp -r $themeDir $out/share/plymouth/themes/
  '';

  meta = with lib; {
    description = "Custom Plymouth theme with NixOS logo";
    homepage = "https://github.com/adi1090x/plymouth-themes";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
