{ lib, ... }:
{
  # Minimal Tor relay defaults; override in custom_machine.nix as needed.
  services.tor = {
    enable = true;
    openFirewall = true;
    settings = {
      Nickname = lib.mkDefault "ChangeMe";
      ContactInfo = lib.mkDefault "admin@example.com";
      MaxAdvertisedBandwidth = lib.mkDefault "10 MB";
      BandwidthRate = lib.mkDefault "5 MB";
      BandwidthBurst = lib.mkDefault "10 MB";
    };
  };
}
