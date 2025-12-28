{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop       # Resource monitor
    lsof       # List open files
    pciutils   # PCI device tools (lspci)
    usbutils   # USB device tools (lsusb)
    lm_sensors # Hardware sensors
    ethtool    # NIC settings and diagnostics
    tcpdump    # Packet capture
    nmap       # Network scanner
    mtr        # Network diagnostics tracer
    bind       # DNS tools (dig, nslookup)
  ];
}
