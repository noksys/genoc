{ config, lib, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      # Requires BOTH Public Key AND Password
      AuthenticationMethods = "publickey,password";
    };
  };
}
