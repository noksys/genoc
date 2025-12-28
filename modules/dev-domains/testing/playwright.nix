{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    playwright-test         # Playwright CLI + bundled browsers
    python3Packages.playwright # Python bindings for Playwright
  ];
}
