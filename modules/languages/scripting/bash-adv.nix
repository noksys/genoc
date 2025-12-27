{ pkgs, ... }: { environment.systemPackages = with pkgs; [ shellcheck shfmt bats ]; }
