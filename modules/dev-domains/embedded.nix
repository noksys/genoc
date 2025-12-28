{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Tools
    platformio   # Embedded build ecosystem
    avrdude      # AVR flashing tool
    openocd      # On-chip debugging
    minicom       # Serial monitor
    
    # PCB Design
    kicad        # PCB design suite
    fritzing     # Breadboard-style schematic tool
    
    # Compilers / Toolchains (Cross)
    pkgsCross.arm-embedded.buildPackages.gcc # ARM bare-metal toolchain
  ];
  
  users.users.${(import ../../../custom_vars.nix).mainUser}.extraGroups = ["dialout"];
}
