{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Engines
    godot_4  # Godot Engine
    unityhub # Unity Hub
    
    # Tools
    ldtk          # 2D Level Editor
    tiled         # Tile map editor
    blender       # Essential for game assets
  ];
}
