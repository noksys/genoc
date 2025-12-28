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
    tpm2-abrmd # TPM2 access broker
    tpm2-tools # TPM2 CLI tools
    tpm2-tss   # TPM2 software stack
    # Other security tools that were coupled with TPM previously
    clevis    # Network-bound disk encryption
    cryptsetup # LUKS tooling
    rng-tools # Hardware RNG tools
    jose      # JOSE utilities
    pamtester # PAM testing tool
  ];
}
