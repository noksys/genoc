{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_20     # Node.js 20.x LTS
    # nodejs_22   # Uncomment for Node.js 22.x Current
    corepack      # Manager for package managers (pnpm, yarn)
  ];
}
