{ pkgs, ... }: { environment.systemPackages = with pkgs; [ ocaml dune_3 opam ocamlPackages.ocaml-lsp ]; }
