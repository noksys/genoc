# Office profile: accounting, document toolchain (LaTeX/PDF), office suite.
#
# Three orthogonal knobs (each null = off):
#
#   accounting = "min" | "full"
#     min  → hledger + ledger (plain-text accounting)
#     full → + gnucash + hledger-web + pricehist (price fetcher)
#
#   docs = "min" | "full"
#     min  → pandoc + tectonic + poppler-utils + okular + mupdf + enscript
#     full → + ocrmypdf, pdftk, qpdf, pdfgrep, typst, unscii, img2pdf
#
#   suite = "min" | "full"
#     min  → libreoffice
#     full → + calibre + kuro
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.genoc.profile.office;
in {
  options.genoc.profile.office = {
    enable = mkEnableOption "office profile";

    accounting = mkOption {
      type = types.nullOr (types.enum [ "min" "full" ]);
      default = null;
    };

    docs = mkOption {
      type = types.nullOr (types.enum [ "min" "full" ]);
      default = null;
    };

    suite = mkOption {
      type = types.nullOr (types.enum [ "min" "full" ]);
      default = null;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.accounting != null) {
      environment.systemPackages = with pkgs; [ hledger ledger ];
    })
    (mkIf (cfg.accounting == "full") {
      environment.systemPackages = with pkgs; [ gnucash hledger-web pricehist ];
    })

    (mkIf (cfg.docs != null) {
      environment.systemPackages = with pkgs; [
        pandoc tectonic poppler-utils kdePackages.okular mupdf enscript
      ];
    })
    (mkIf (cfg.docs == "full") {
      environment.systemPackages = with pkgs; [
        ocrmypdf pdftk qpdf pdfgrep typst unscii img2pdf
      ];
    })

    (mkIf (cfg.suite != null) {
      environment.systemPackages = with pkgs; [ libreoffice ];
    })
    (mkIf (cfg.suite == "full") {
      environment.systemPackages = with pkgs; [ calibre kuro ];
    })
  ]);
}
