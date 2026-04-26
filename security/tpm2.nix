# TPM 2.0 (Trusted Platform Module). Enables the kernel modules, the
# tctiEnvironment + PKCS#11 layer, and adds the user to the `tss` group.
# Userspace tools (tpm2-tools, tpm2-abrmd, tpm2-tss) ship with the
# always-on pkgs/security.nix bundle.
{ config, lib, pkgs, ... }:

with lib;

let
  vars = import ../../custom_vars.nix;
in {
  options.genoc.security.tpm2.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf config.genoc.security.tpm2.enable {
    security.tpm2.enable = true;
    security.tpm2.pkcs11.enable = true;
    security.tpm2.tctiEnvironment.enable = true;
    users.users."${vars.mainUser}".extraGroups = [ "tss" ];

    boot.kernelModules        = [ "tpm" "tpm_tis" "tpm_crb" ];
    boot.initrd.kernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];
  };

  # NOTE: pkgs/security.nix is now imported once from common.nix (always-on);
  # tpm2.nix used to pull it via environment.systemPackages, that's gone.
}
