{ pkgs, ... }:
let
  paisaFlake = builtins.getFlake "github:ananthakumaran/paisa";
  paisaPkg   = paisaFlake.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = [ paisaPkg ];
}
