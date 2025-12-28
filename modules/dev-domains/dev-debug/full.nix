{ pkgs, ... }:

{
  imports = [
    ./regular.nix
  ];

  environment.systemPackages = with pkgs; [
    rr     # Record and replay debugger
    gdbgui # Browser-based GDB frontend
  ];
}
