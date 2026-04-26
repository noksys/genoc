# Crypto profile: chain wallets, full nodes, hardware-wallet UIs.
#
# Two knobs:
#
#   genoc.profile.crypto-node.coins.<coin> = "wallet" | "node"
#       wallet → just the GUI client (which usually runs its own daemon
#                bound to localhost when launched)
#       node   → wallet + standalone daemon + Tor onion service mapping
#                the chain port (where applicable)
#       Recognized coins: btc, liquid, xmr, namecoin.
#
#   genoc.profile.crypto-node.wallets = "min" | "full"
#       min  → hardware-wallet UIs (Ledger Live, Trezor Suite)
#       full → + Sparrow (multisig, hwwallets), Wasabi (CoinJoin)
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.crypto-node;

  hasCoinNode = coin: (cfg.coins.${coin} or null) == "node";
  hasCoinAny  = coin: cfg.coins ? ${coin};

  hasWallets  = cfg.wallets == "min" || cfg.wallets == "full";
  fullWallets = cfg.wallets == "full";
in {
  options.genoc.profile.crypto-node = {
    enable = mkEnableOption "crypto-node profile";

    coins = mkOption {
      type = types.attrsOf (types.enum [ "wallet" "node" ]);
      default = {};
      example = { btc = "node"; liquid = "node"; xmr = "wallet"; };
      description = ''
        Per-chain depth. Recognized coins: btc, liquid, xmr, namecoin.
        Coins absent from the attrset install nothing.
      '';
    };

    wallets = mkOption {
      type = types.nullOr (types.enum [ "min" "full" ]);
      default = null;
      example = "full";
      description = "Hardware/multisig/privacy wallet UIs. null = none.";
    };

    btcVariant = mkOption {
      type = types.enum [ "knots" "core" ];
      default = "knots";
      description = ''
        Which Bitcoin client to install when coins.btc is set:
        - knots: bitcoin-knots GUI + bitcoind-knots daemon (more conservative
                 mempool policy; rejects inscriptions, etc.)
        - core:  vanilla Bitcoin Core upstream (bitcoin + bitcoind)
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # ── Bitcoin ──────────────────────────────────────────────────────────────
    (mkIf (hasCoinAny "btc" && cfg.btcVariant == "knots") {
      environment.systemPackages = [ pkgs.bitcoin-knots ];   # GUI (bitcoin-qt)
    })
    (mkIf (hasCoinAny "btc" && cfg.btcVariant == "core") {
      environment.systemPackages = [ pkgs.bitcoin ];         # vanilla Bitcoin Core GUI
    })
    (mkIf (hasCoinNode "btc" && cfg.btcVariant == "knots") {
      environment.systemPackages = with pkgs; [ bitcoind-knots electrs ];
      services.tor.relay.onionServices.bitcoin = {
        version = 3;
        map = [{ port = 8333; target = { addr = "127.0.0.1"; port = 8333; }; }];
      };
    })
    (mkIf (hasCoinNode "btc" && cfg.btcVariant == "core") {
      environment.systemPackages = with pkgs; [ bitcoind electrs ];
      services.tor.relay.onionServices.bitcoin = {
        version = 3;
        map = [{ port = 8333; target = { addr = "127.0.0.1"; port = 8333; }; }];
      };
    })

    # ── Liquid (Elements) ────────────────────────────────────────────────────
    (mkIf (hasCoinAny "liquid") {
      environment.systemPackages = with pkgs; [
        elements                     # elements-qt + tools
      ];
    })
    (mkIf (hasCoinNode "liquid") {
      services.tor.relay.onionServices.elements = {
        version = 3;
        map = [{ port = 17041; target = { addr = "127.0.0.1"; port = 17041; }; }];
      };
    })

    # ── Monero ───────────────────────────────────────────────────────────────
    (mkIf (hasCoinAny "xmr") {
      environment.systemPackages = with pkgs; [ monero-gui ];
    })

    # ── Namecoin ─────────────────────────────────────────────────────────────
    (mkIf (hasCoinAny "namecoin") {
      environment.systemPackages = with pkgs; [
        namecoind                    # Namecoin daemon
        ncdns                        # Namecoin → DNS bridge
      ];
    })

    # ── Wallet UIs ───────────────────────────────────────────────────────────
    (mkIf hasWallets {
      environment.systemPackages = with pkgs; [
        ledger-live-desktop          # Ledger HW wallet UI
        trezor-suite                 # Trezor HW wallet UI
      ];
    })
    (mkIf fullWallets {
      environment.systemPackages = with pkgs; [
        sparrow                      # multisig + hwwallets
        wasabiwallet                 # CoinJoin / privacy
      ];
    })
  ]);
}
