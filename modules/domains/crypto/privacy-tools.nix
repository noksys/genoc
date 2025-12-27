{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    monero-gui # Private digital currency
    trezor-suite # Hardware wallet interface
    ledger-live-desktop # Hardware wallet interface
    wasabiwallet # Privacy-focused Bitcoin wallet
  ];
}
