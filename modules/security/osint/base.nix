{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sherlock    # Username enumeration
    maltego     # OSINT graph analysis
    theharvester # Email/domain OSINT
    holehe      # Email account discovery
  ];
}
