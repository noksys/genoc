{ pkgs }:

with pkgs; [
  age                    # modern file encryption
  age-plugin-fido2-hmac  # FIDO2-backed identity for age
  clevis
  cryptsetup
  ddrescue               # robust data recovery
  jose
  libfido2
  pam_u2f
  pamtester
  rng-tools
  sleuthkit              # file system forensics
  tpm2-abrmd
  tpm2-tools
  tpm2-tss
  volatility3            # memory forensics
  yubikey-manager
  yubikey-personalization
]
