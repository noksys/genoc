{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    retroarchFull
    dosbox
    scummvm
    dolphin-emu
    pcsx2
  ];
}
