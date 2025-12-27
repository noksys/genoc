{ pkgs, ... }: { networking.firewall.enable = true; networking.firewall.extraCommands = "iptables -A INPUT -p icmp --icmp-type echo-request -j DROP"; }
