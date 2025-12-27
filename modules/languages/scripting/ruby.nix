{ pkgs, ... }: { environment.systemPackages = with pkgs; [ ruby ruby-lsp rubocop ]; }
