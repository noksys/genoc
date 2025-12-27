{ config, lib, pkgs, ... }:

let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.kernelPackages = latestKernelPackage;
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ]; # 12GB
  
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  boot.kernelModules = [ "zfs" ];
}
