{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../../hardware-configuration.nix
    ../sound/pulseaudio.nix
    ./no_hibernation.nix
    ./no_sleep.nix
  ];

  services.pipewire.enable = false;

  # Virtualization
  virtualisation.vmware.guest.enable = true;
  #virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      open-vm-tools
    ])
  ];

  fileSystems."/mnt/hgfs" = {
    device = lib.mkForce ".host:/";
    fsType = lib.mkForce "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = lib.mkForce ["umask=22" "uid=1000" "gid=1000" "allow_other" "defaults" "auto_unmount"];
  };

  systemd.services.vmtoolsd = {
    enable = true;
    description = "Open VM Tools Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.open-vm-tools}/bin/vmtoolsd";
      Restart = "always";
    };
  };
}
