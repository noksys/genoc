{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop       # Resource monitor
    htop       # Interactive process viewer
    iotop      # Disk I/O monitor
    lsof       # List open files
    pciutils   # PCI device tools (lspci)
    usbutils   # USB device tools (lsusb)
    lm_sensors # Hardware sensors
    ethtool    # NIC settings and diagnostics
    tcpdump    # Packet capture
    nmap       # Network scanner
    mtr        # Network diagnostics tracer
    bind       # DNS tools (dig, nslookup)
    jq         # JSON manipulation
  ];
}
