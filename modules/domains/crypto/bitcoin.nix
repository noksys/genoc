{ pkgs, ... }: { environment.systemPackages = [ pkgs.bitcoind pkgs.bitcoin ]; }
