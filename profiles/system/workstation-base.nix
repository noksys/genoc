{ pkgs, ... }:

{
  imports = [
    ../../modules/sys-utils/nix-ld.nix
    ../../modules/ui/fonts/emoji.nix
    ../../modules/hardware/peripherals/bluetooth.nix
    ../../modules/hardware/peripherals/xbox-controller.nix
  ];
}
