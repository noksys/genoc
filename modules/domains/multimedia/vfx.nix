{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    natron        # Node-based compositing software
    ffmpeg-full   # The swiss army knife (full codec support)
    mediainfo     # Media metadata inspector
  ];
}
