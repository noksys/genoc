{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flightgear
    opentrack     # Head tracking
    joystickwake  # Keep screen on when using joystick
  ];
}
