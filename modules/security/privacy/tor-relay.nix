{ ... }:
let
  vars = import ../../../../custom_vars.nix;
in
{
  # Tor Service Configuration
  services.tor = {
    enable = true;
    openFirewall = true;
    enableGeoIP = false;
    torsocks.enable = true;
#    openFirewall = true;
    client.enable = true;
    relay.enable = false;

#     relay = {
#       enable = true;
#       role = "relay";  # Set the relay role (e.g., "relay", "bridge")
#     };

    settings = {
      #Nickname = "Lazy Guy";
      #ContactInfo = "lazyguy@example.com";

      MaxAdvertisedBandwidth = "10 MB";
      BandWidthRate = "5 MB";
      BandwidthBurst = "10 MB";
      #RelayBandwidthRate = "5 MB";
      #RelayBandwidthBurst = "10 MB";

      # Restrict exit nodes to a specific country (use the appropriate country code)
      #ExitNodes = "{ch} StrictNodes 1";

      # Reject all exit traffic
      ExitPolicy = ["reject *:*"];

      # Performance and security settings
      CookieAuthentication = true;
      CookieAuthFileGroupReadable = true;
      DataDirectoryGroupReadable = true;
      AvoidDiskWrites = 1;
      HardwareAccel = 1;

      ControlPort = 9051;
      HashedControlPassword = "${vars.torControlPasswordHash}";

      # Network settings
      #ORPort = [443];

      #Log = "debug stderr";
      SafeLogging = 1;
    };
  };
}
