{ config, lib, pkgs, vars, ... }:
{
  # =========================================================================
  # LEGACY USER CONFIGURATION
  # Extracted from genoc/configuration.nix during refactoring.
  # Move these to your private custom_machine.nix or common.nix if needed.
  # =========================================================================

  # Custom user packages (broken import previously)
  # users.users.${vars.mainUser}.packages = ... (import ./pkgs/default_user.nix)

  # Tor Service Configuration
  services.tor = {
    enable = true;
    enableGeoIP = false;
    torsocks.enable = true;
    client.enable = true;
    relay.enable = false;
    settings = {
      MaxAdvertisedBandwidth = "10 MB";
      BandWidthRate = "5 MB";
      BandwidthBurst = "10 MB";
      ExitPolicy = ["reject *:*"];
      CookieAuthentication = true;
      CookieAuthFileGroupReadable = true;
      DataDirectoryGroupReadable = true;
      AvoidDiskWrites = 1;
      HardwareAccel = 1;
      ControlPort = 9051;
      HashedControlPassword = "${vars.torControlPasswordHash}"; # Requires vars
      SafeLogging = 1;
    };
  };

  # PCSCD
  services.pcscd.enable = true;

  # HDR support
  services.colord.enable = true;

  # Printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = false;
  };

  # Local web server via i2p (Puma/Nginx)
  services.nginx = {
    enable = false;
    virtualHosts."localhost" = {
      root = "/var/www/puma.i2p";
      listen = [ { addr = "127.0.0.1"; port = 591; } ];
      locations."/" = {};
    };
    commonHttpConfig = ''
      log_format puma_access ...;
      limit_req_zone ...;
      limit_conn_zone ...;
    '';
    appendHttpConfig = ''
      access_log /var/log/nginx/access.log puma_access;
    '';
  };

  # I2P
  services.i2pd = {
    enable = true;
    outTunnels = {
      "MUMBLE-ACETONE-TCP" = {
        address = "127.0.0.1"; port = 64738;
        destination = "plpu63ftpi5wdr42ew7thndoyaclrjqmcmngu2az4tahfqtfjoxa.b32.i2p";
        destinationPort = 64738; keys = "transient-mumble-acetone";
      };
    };
  };
  
  # Bind mounts
  fileSystems."/var/lib/i2pd" = { device = "${vars.homeDirectory}/parked/auth/i2p"; options = [ "bind" ]; };
  fileSystems."/var/www/puma.i2p" = { device = "${vars.homeDirectory}/www/puma.i2p"; options = [ "bind" ]; };

  # Specific Systemd Services
  # systemd.user.services.nginx-notify = { ... };
  # systemd.user.services.nginx-banwatch = { ... };
  # systemd.services.backup-screensaver = { ... };
  # systemd.timers.backup-screensaver = { ... };

  # SDDM YubiKey
  security.pam.services.sddm.text = lib.mkForce ''...pam_u2f...'';

  # Games
  programs.steam.enable = true;
}
