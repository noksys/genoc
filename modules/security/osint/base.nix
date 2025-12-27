{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sherlock
    maltego
    theharvester
    holehe
  ];
}
