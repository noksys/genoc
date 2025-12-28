{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # --- Wallets ---
    electrum              # Lightweight Bitcoin wallet
    sparrow               # Modern Bitcoin Wallet
    wasabiwallet          # Privacy focused Bitcoin wallet
    monero-gui            # Monero Wallet
    
    # --- Tools ---
    # python3Packages.bitbox02 # BitBox02 hardware wallet library
  ];
}
