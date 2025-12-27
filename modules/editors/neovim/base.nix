{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim                # Vim-fork focused on extensibility and usability
  ];
}
