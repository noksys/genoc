# ZFS support: latest ZFS-compatible kernel, autoScrub, trim, autoSnapshot.
# ARC capped at 12 GB so a 64 GB box doesn't surrender half its RAM to
# the cache. The `-k -p` autoSnapshot flags preserve snapshots on
# destroy/rename and keep full paths.
{ config, lib, pkgs, ... }:

with lib;

let
  zfsCompatibleKernelPackages = filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = last (
    sort (a: b: (versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in {
  options.genoc.hardware.zfs.enable = mkOption {
    type = types.bool;
    default = true;
    description = "ZFS support (kernel modules, ARC cap, autoScrub, trim, autoSnapshot).";
  };

  config = mkIf config.genoc.hardware.zfs.enable {
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.forceImportRoot = false;
    boot.kernelPackages = latestKernelPackage;
    boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ]; # 12 GB

    boot.kernelModules = [ "zfs" ];

    services.zfs.autoScrub.enable = true;
    services.zfs.trim.enable = true;
    services.zfs.autoSnapshot = {
      enable = true;
      flags  = "-k -p";  # preserve on destroy/rename, keep full path
    };
  };
}
