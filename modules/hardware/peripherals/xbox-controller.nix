{ pkgs, ... }: { 
  hardware.bluetooth.enable = true; 
  hardware.bluetooth.powerOnBoot = true; 
  services.blueman.enable = true; 
  hardware.xpadneo.enable = true; # Advanced Linux driver for Xbox One wireless controllers
}
