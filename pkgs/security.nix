{ pkgs }:

with pkgs; [
  age                       # modern file encryption (rage-compatible)
  age-plugin-fido2-hmac     # FIDO2-backed identity for age
  clevis                    # automated decryption framework (TPM/Tang)
  cryptsetup                # LUKS userspace
  ddrescue                  # robust data recovery for failing disks
  jose                      # JOSE (JSON Web Token / JWS / JWE) tooling
  libfido2                  # FIDO2 / WebAuthn library + CLI
  mkpasswd                  # crypt(3) password hash CLI (mkpasswd -m sha-512)
  pam                       # PAM userspace
  pam_u2f                   # PAM module for FIDO U2F/CTAP1
  pamtester                 # exercise/test PAM stacks from CLI
  rng-tools                 # /dev/random feeder (RDRAND/jitter/etc.)
  sleuthkit                 # filesystem forensics toolkit
  tpm2-abrmd                # TPM2 access broker (resource manager)
  tpm2-tools                # TPM2 CLI tools
  tpm2-tss                  # TPM2 software stack libs
  volatility3               # memory image forensics
  yubikey-manager           # GUI/CLI for YubiKey configuration (ykman)
  yubikey-personalization   # YubiKey provisioning tool (ykpersonalize)
]
