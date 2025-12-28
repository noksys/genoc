{ ... }:

{
  # Enforce Google SafeSearch via DNS (FamilyShield by OpenDNS)
  networking.nameservers = [ "208.67.222.123" "208.67.220.123" ];

  # Time limits (Example: logoff at 22:00)
  # systemd.services.force-logoff = { ... };
  
}
