{ config, lib, pkgs, modulesPath, ... }:

let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in
{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vscode-1.86.2"
    ];

    permittedInsecurePackages = [
      "openssl-1.1.1u"
      "qtwebkit-5.212.0-alpha4"
    ];

    packageOverrides = pkgs: {
      vscode = unstable.vscode;
    };
  };

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      wmctrl
      xorg.xprop
      ])
  ];
}
