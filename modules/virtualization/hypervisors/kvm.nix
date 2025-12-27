{ pkgs, ... }:
{
  # Enable libvirtd (System-level config required in configuration.nix, but packages here)
  environment.systemPackages = with pkgs; [
    qemu_full             # Generic and open source machine emulator and virtualizer
    libvirt               # Toolkit to interact with the virtualization capabilities of Linux
    virt-manager          # Desktop user interface for managing virtual machines
    virt-viewer           # A viewer for remote virtual machines
    bridge-utils          # Utilities for configuring the Linux Ethernet bridge
    dnsmasq               # Lightweight DNS forwarder and DHCP server
    ebtables              # A tool for manipulating the Ethernet bridge frame table
    dmidecode             # A tool that reads the DMI table
  ];
  
  # Note: You usually need `virtualisation.libvirtd.enable = true;` in your system config.
}
