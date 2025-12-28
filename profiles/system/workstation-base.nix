{ pkgs, ... }:

{
  imports = [
    ../../modules/sys-utils/nix-ld.nix
    ../../modules/security/vpn/wireguard.nix
    ../../modules/ui/common-gui.nix
    ../../modules/ui/terminal-emulators/base.nix
    ../../modules/system/shells/base.nix
    ../../modules/ui/fonts/emoji.nix
    ../../modules/hardware/peripherals/bluetooth.nix
    ../../modules/hardware/peripherals/xbox-controller.nix
  ];
}
