{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  boot = {
    plymouth = {
      enable = true;
      theme = "${vars.plymouthTheme}";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "${vars.plymouthTheme}" ];
        })
      ];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = lib.mkDefault (config.boot.kernelParams ++ [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ]);
  };

  system.activationScripts.copyPlymouthAssets = ''
    themeDir="/etc/plymouth/themes/${vars.plymouthTheme}"
    mkdir -p "$themeDir"
    cp ${./nixos.png} "$themeDir/"
    scriptFile="$themeDir/${vars.plymouthTheme}.script"
    if [ -f "$scriptFile" ]; then
      echo '
      # display nixos logo
      nixos_image = Image("nixos.png");
      nixos_sprite = Sprite();
      nixos_sprite.SetImage(nixos_image);
      nixos_sprite.SetX(Window.GetX() + (Window.GetWidth() / 2 - nixos_image.GetWidth() / 2));
      nixos_sprite.SetY(Window.GetHeight() - nixos_image.GetHeight() - 50);
      ' >> "$scriptFile"
    fi

    plymouth-set-default-theme --reset --rebuild-initrd "${vars.plymouthTheme}" --theme-dir="/etc/plymouth/themes"
  '';

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
       adi1090x-plymouth-themes
       plymouth
    ])
  ];
}
