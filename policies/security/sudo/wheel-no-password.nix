{ config, lib, pkgs, ... }:

let
  vars = import ../../../../custom_vars.nix;
in
{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false; # Allow wheel group to sudo without password
    
    # Allow power management commands without password explicitly 
    extraRules = [{
      commands = [
        { command = "${pkgs.systemd}/bin/systemctl suspend"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.systemd}/bin/reboot"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.systemd}/bin/poweroff"; options = [ "NOPASSWD" ]; }
      ];
      groups = [ "wheel" "docker" ];
    }];
  };

  users.users.${vars.mainUser}.extraGroups = [ "wheel" ];
}
