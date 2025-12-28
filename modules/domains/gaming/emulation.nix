{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    retroarchFull # Multi-system emulator frontend
    dosbox        # DOS emulator
    scummvm       # Classic point-and-click engine
    dolphin-emu   # GameCube/Wii emulator
    pcsx2         # PlayStation 2 emulator
  ];
}
