{ pkgs, ... }:
{
  imports = [ ./regular.nix ];
  
  environment.systemPackages = with pkgs; [
    # --- Professional Production ---
    blender               # 3D Creation/Animation/Publishing System
    kdenlive              # Non-linear video editor
    obs-studio            # Free and open source software for video recording and live streaming
    ffmpeg-full           # A complete, cross-platform solution to record, convert and stream audio and video
    imagemagick           # A software suite to create, edit, compose, or convert bitmap images
    darktable             # Virtual lighttable and darkroom for photographers
    ardour                # Digital Audio Workstation (DAW)
  ];
}
