{ pkgs, ... }: { 
  imports = [ ./base.nix ./elements.nix ./wallets.nix ];
  environment.systemPackages = with pkgs; [
    electrum # Lightweight Bitcoin wallet
    sparrow  # Feature-rich Bitcoin wallet
  ];
}
