{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flightgear    # Flight simulator
    opentrack     # Head tracking
    joystickwake  # Keep screen on when using joystick
  ];
}
