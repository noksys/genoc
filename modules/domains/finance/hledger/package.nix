{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hledger     # CLI accounting tool
    hledger-ui  # TUI interface
    hledger-web # Web UI
  ];
}
