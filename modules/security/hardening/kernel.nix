{ pkgs, ... }:
{
  # Kernel Hardening (Basic Paranoid Defaults)
  boot.kernel.sysctl = {
    "kernel.dmesg_restrict" = 1;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
  };
}
