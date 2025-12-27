{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blender
    meshlab
    freecad
  ];
}
