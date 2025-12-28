{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    i2pd # I2P daemon (Invisible Internet Project)
  ];
}
