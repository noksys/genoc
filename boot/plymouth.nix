{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  boot = {
    initrd.systemd.enable = true;

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

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
       adi1090x-plymouth-themes
       plymouth
    ])
  ];
}
