{ pkgs, ... }: { environment.systemPackages = [ pkgs.pulseview pkgs.sigrok-cli ]; }
