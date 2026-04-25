{ pkgs }:

with pkgs; [
  #bisq-desktop                # decentralized exchange — kept commented (rare use)
  #electron-cash               # BCH wallet — kept commented
  #bitcoin                     # vanilla Bitcoin Core (you run knots instead)
  bitcoin-knots                # Bitcoin Knots GUI (bitcoin-qt)
  bitcoind-knots               # Bitcoin Knots daemon (separate from GUI in nixpkgs)
  electrs                      # Electrum server backend (Rust)
  #electrum                    # use the AppImage directly (better release cadence)
  elements                     # Liquid Network sidechain (elements-qt + tools)
  ledger-live-desktop          # Ledger HW wallet UI
  monero-gui                   # Monero (XMR) wallet
  namecoind                    # Namecoin (NMC) daemon
  ncdns                        # Namecoin → DNS bridge
  sparrow                      # feature-rich Bitcoin wallet (multisig, hwwallets)
  trezor-suite                 # Trezor HW wallet UI
  wasabiwallet                 # privacy-focused Bitcoin wallet (CoinJoin)
]
