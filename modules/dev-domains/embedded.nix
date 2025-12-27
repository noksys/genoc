{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Tools
    platformio
    avrdude
    openocd
    minicom       # Serial monitor
    
    # PCB Design
    kicad
    fritzing
    
    # Compilers / Toolchains (Cross)
    pkgsCross.arm-embedded.buildPackages.gcc
  ];
  
  users.users.${(import ../../custom_vars.nix).mainUser}.extraGroups = ["dialout"];
}
