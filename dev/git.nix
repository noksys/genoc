{ config, lib, pkgs, modulesPath, ... }:

{
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
    };
  };

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      git
    ])
  ];
}
