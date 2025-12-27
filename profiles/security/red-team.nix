{ pkgs, ... }:

{
  imports = [
    ../../modules/security/pentesting/full.nix # Metasploit, etc
  ];

  environment.systemPackages = with pkgs; [
    wireshark
    nmap
    burpsuite
    aircrack-ng
    john
    sqlmap
  ];
}
