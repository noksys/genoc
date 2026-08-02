# TPM 2.0 (Trusted Platform Module). Enables the kernel modules and the
# tctiEnvironment + PKCS#11 layer. Whether the main user gets unprivileged
# access to the TPM is a separate decision — see userTssGroup below.
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

  # WHY THIS DEFAULTS TO FALSE
  #
  # /dev/tpmrm0 is root:tss 0660 and /dev/tpm0 is root:root, so the `tss`
  # group is the whole access decision for userspace. tpm2-abrmd is not
  # running and claims no name on the system bus, so there is no second path.
  #
  # Membership is not abstract here: ~/parked/auth/*.jwe are clevis blobs with
  # a tpm2 pin ({"alg":"dir","clevis":{"pin":"tpm2"}}). A tpm2 pin unseals
  # non-interactively by design — as long as the machine booted normally, the
  # TPM hands the key back with no password, no touch and no prompt. With the
  # user in `tss`, ANY process running as that user unseals them: a shell
  # script, a compromised dependency, an AI agent reading the directory.
  #
  # That is the shortest path to those secrets on this machine, and it is
  # shorter than every control layered above it — the KeePassXC database is
  # protected by a YubiKey challenge-response that requires a physical touch,
  # and the blob beside it opens silently.
  #
  # Leaving the user out of `tss` does not remove the capability, it moves it
  # behind sudo, where genoc.security.sudo2fa makes it cost a YubiKey touch:
  #
  #   clevis decrypt < ~/parked/auth/pwd.jwe        -> fails, no TPM access
  #   sudo clevis decrypt < ~/parked/auth/pwd.jwe   -> works, one touch
  #
  # Nothing in this configuration needs it on. setup-privileged.sh is the only
  # consumer of clevis and it already refuses to run unprivileged (line 71:
  # `[ "$(id -u)" -eq 0 ] || die "must run as root (via sudo)"`); root reaches
  # the TPM regardless of group. Its block comment at lines 43-44, claiming the
  # tss membership avoids privilege escalation, predates that guard and is
  # stale. Nothing on this machine uses tpm2-pkcs11 from a user session.
  options.genoc.security.tpm2.userTssGroup = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Add the main user to the `tss` group, granting unprivileged access to
      /dev/tpmrm0. Turn this on only if a user-session workload genuinely
      needs the TPM without sudo; clevis tpm2 pins on disk become silently
      unsealable by anything running as that user when it is on.
    '';
  };

  config = mkIf config.genoc.security.tpm2.enable {
    security.tpm2.enable = true;
    security.tpm2.pkcs11.enable = true;
    security.tpm2.tctiEnvironment.enable = true;

    users.users."${vars.mainUser}".extraGroups =
      optionals config.genoc.security.tpm2.userTssGroup [ "tss" ];

    boot.kernelModules        = [ "tpm" "tpm_tis" "tpm_crb" ];
    boot.initrd.kernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];
  };

  # NOTE: pkgs/security.nix is now imported once from common.nix (always-on);
  # tpm2.nix used to pull it via environment.systemPackages, that's gone.
}
