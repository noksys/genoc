{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clamav                # Antivirus engine for detecting trojans, viruses, malware and other malicious threats
    clamtk                # Graphical user interface for ClamAV
  ];
  
  # Optional: Enable the daemon
  # services.clamav.daemon.enable = true;
  # services.clamav.updater.enable = true;
}
