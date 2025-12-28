{ pkgs, ... }:

{
  imports = [ ./communication/full.nix ];

  environment.systemPackages = with pkgs; [
    whatsapp-for-linux # WhatsApp desktop client
    zoom-us            # Zoom client
    teams-for-linux    # Microsoft Teams client
    viber              # Viber client
    weechat            # IRC TUI client
  ];
}
