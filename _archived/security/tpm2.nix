{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ../../custom_vars.nix;
in
{
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
  users.users."${vars.mainUser}".extraGroups = [ "tss" ];

  boot.kernelModules = lib.mkMerge [[ "tpm" "tpm_tis" "tpm_crb" ]];
  boot.initrd.kernelModules = lib.mkMerge [[ "tpm" "tpm_tis" "tpm_crb" ]];

  environment.systemPackages = lib.mkMerge [
    (import ../pkgs/security.nix { pkgs = pkgs; })
  ];
}
