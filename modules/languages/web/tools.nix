{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    typescript              # Typed subset of JavaScript
    nodePackages.typescript-language-server # LSP for TypeScript
    nodePackages.eslint     # Pluggable linting utility for JavaScript and JSX
    nodePackages.prettier   # Opinionated code formatter
    nodePackages.vls        # Vue Language Server
    nodePackages.vscode-langservers-extracted # HTML/CSS/JSON/ESLint LSPs
  ];
}
