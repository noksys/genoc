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

      extraConfig = ''
        InputTimeout=0
      '';
    };

    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = lib.mkBefore [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=4"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "plymouth.enable-logo=false"
      "plymouth.debug=true"
      "plymouth.ignore-serial-consoles"
      "rd.luks.options=timeout=0"
      "rd.timeout=0"
      "rootflags=x-systemd.device-timeout=0"
    ];
  };

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
       adi1090x-plymouth-themes
       plymouth
    ])
  ];
}
