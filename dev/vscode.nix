{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];
    permittedInsecurePackages = [
      "openssl-1.1.1u"
      "qtwebkit-5.212.0-alpha4"
    ];
  };

  environment.systemPackages = with pkgs; [
    wmctrl
    xorg.xprop
    vscode
  ];
}
