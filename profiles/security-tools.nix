# Security-tools profile: cryptography utilities (age, cryptsetup,
# libfido2, pam tooling), forensics CLIs (sleuthkit, volatility3,
# ddrescue), TPM2 userspace, YubiKey management. Always-on by default;
# these are general-purpose admin tools, not specialized workloads.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.security-tools;
in {
  options.genoc.profile.security-tools = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      age                       # modern file encryption (rage-compatible)
      age-plugin-fido2-hmac     # FIDO2-backed identity for age
      clevis                    # automated decryption framework (TPM/Tang)
      cryptsetup                # LUKS userspace
      ddrescue                  # robust data recovery for failing disks
      jose                      # JOSE (JWT/JWS/JWE) tooling
      libfido2                  # FIDO2 / WebAuthn library + CLI
      mkpasswd                  # crypt(3) password hash CLI
      pam                       # PAM userspace
      pam_u2f                   # PAM module for FIDO U2F/CTAP1
      pamtester                 # exercise/test PAM stacks from CLI
      rng-tools                 # /dev/random feeder
      sleuthkit                 # filesystem forensics toolkit
      tpm2-abrmd                # TPM2 access broker (resource manager)
      tpm2-tools                # TPM2 CLI tools
      tpm2-tss                  # TPM2 software stack libs
      volatility3               # memory image forensics
      yubikey-manager           # GUI/CLI for YubiKey configuration
      yubikey-personalization   # YubiKey provisioning tool
      gitleaks                  # git history / staged secret scanner
    ];
  };
}
