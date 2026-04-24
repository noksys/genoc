{ pkgs, ... }:

{
  imports = [
    ../../modules/sys-utils/nix-ld.nix
    ../../modules/security/vpn/wireguard.nix
    ../../modules/ui/common-gui.nix
    ../../modules/ui/terminal-emulators/base.nix
    ../../modules/system/shells/base.nix
    ../../modules/domains/multimedia/audio-cli.nix
    ../../modules/ui/fonts/emoji.nix
    ../../modules/hardware/peripherals/bluetooth.nix
    ../../modules/hardware/peripherals/xbox-controller.nix
  ];

  # WORKAROUND: nixpkgs 25.11 telegram-desktop fails with zlib 1.3.2 (zip.h path changed).
  # Fix from nixpkgs PR #499107: use minizip-ng instead of minizip.
  # Remove once nixos-25.11 channel propagates commit c55e998c5981.
  nixpkgs.overlays = [
    (_: prev: {
      telegram-desktop = prev.telegram-desktop.override {
        unwrapped = prev.telegram-desktop.unwrapped.overrideAttrs (old: {
          buildInputs =
            builtins.filter (p: (p.pname or "") != "minizip") (old.buildInputs or [])
            ++ [ prev.minizip-ng ];
          # Fix sign-conversion error in ThirdParty/dispatch with clang 21
          postPatch = (old.postPatch or "") + ''
            substituteInPlace Telegram/ThirdParty/dispatch/src/event/event_epoll.c \
              --replace-fail \
                'return dmn->dmn_events & ~dmn->dmn_disarmed_events;' \
                'return dmn->dmn_events & ~(uint32_t)dmn->dmn_disarmed_events;'
          '';
        });
      };
    })
  ];

  services.netbird.enable = true;

  environment.systemPackages = with pkgs; [
    kuro
    ripgrep
    mumble
    azure-cli
    teamspeak3
    libreoffice
    discord
    parallel-full
    netbird-ui
    terminator
    python3
    code-cursor
    uv
    taskjuggler
    typst
  ];
}

