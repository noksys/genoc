{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blender # 3D creation suite
    meshlab # Mesh processing
    freecad # Parametric CAD
  ];
}
