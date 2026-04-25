{ pkgs }:

with pkgs; [
  #bisq-desktop
  #electron-cash
  #bitcoin
  bitcoin-knots         # GUI (bitcoin-qt)
  bitcoind-knots        # daemon (separate from the GUI in nixpkgs)
  electrs
  #electrum             # use the AppImage directly (better release cadence)
  elements
  ledger-live-desktop   # Ledger HW wallet UI
  monero-gui            # Monero wallet
  namecoind
  ncdns
  sparrow               # feature-rich Bitcoin wallet
  trezor-suite          # Trezor HW wallet UI
  wasabiwallet          # privacy-focused Bitcoin wallet
]
