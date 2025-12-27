{ config, lib, pkgs, ... }:

let
  vars = import ../../../custom_vars.nix;
in
{
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
  users.users."${vars.mainUser}".extraGroups = [ "tss" ];

  boot.kernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];
  boot.initrd.kernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];

  environment.systemPackages = with pkgs; [
    tpm2-abrmd
    tpm2-tools
    tpm2-tss
    # Other security tools that were coupled with TPM previously
    clevis
    cryptsetup
    rng-tools
    jose
    pamtester
  ];
}
