# VMware / vmware-tools guest. Active when genoc.hardware.machine = "vmware".
{ config, lib, pkgs, ... }:

lib.mkIf (config.genoc.hardware.machine == "vmware") {
  services.xserver.videoDrivers = [ "vmware" ];

  virtualisation.vmware.guest.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [ open-vm-tools ];

  fileSystems."/mnt/hgfs" = {
    device  = lib.mkForce ".host:/";
    fsType  = lib.mkForce "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = lib.mkForce [ "umask=22" "uid=1000" "gid=1000" "allow_other" "defaults" "auto_unmount" ];
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
