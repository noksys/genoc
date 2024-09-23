{ config, lib, pkgs, modulesPath, ... }:

let
  vars = import ./custom_vars.nix;
in
{
  imports = [
    ./genoc/hardware/vmware.nix # choose between vmware.nix or baremetal.nix

    ./genoc/locale/ptbr.nix     # define locale
    ./genoc/ui/kde.nix          # can be KDE, Gnome, LXQt etc.
    ./genoc/boot/grub.nix       # can be systemd-boot

    # optional:
    ./genoc/backup/tarsnap.nix
    ./genoc/dev/vscode.nix
    ./genoc/dev/docker.nix
    ./genoc/ui/fonts.nix
    ./genoc/cryptocurrency/bitcoin.nix
    ./genoc/cryptocurrency/liquid.nix
    #./genoc/security/tpm2.nix
    #./genoc/cryptocurrency/electrum.nix
    #./genoc/hardware/coldcard.nix
  ];

  # File Systems
  #fileSystems."/home_RENAME" =
  #  { device = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
  #    fsType = "ext4";
  #    options = [ "noatime" ];
  #  };
  #
  #fileSystems."/wa" =
  #  { device = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
  #    fsType = "ext4";
  #    options = [ "noatime" ];
  #  };

  # Swap
  #swapDevices =
  #   [ { device = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; }
  #   ];

  # Cron Jobs
  #services.cron = {
  #  enable = true;
  #  systemCronJobs = [
  #    "0 16,20 * * * root ${vars.homeDirectory}/make-backup.sh > ${vars.homeDirectory}/last-backup.log 2>&1"
  #  ];
  #};

  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      # custom pkgs

        # Custom menu items
#         (writeTextFile {
#           name = "sqlitestudio.desktop";
#           destination = "/share/applications/sqlitestudio.desktop";
#           text = ''
#             [Desktop Entry]
#             Type=Application
#             Name=SQLite Studio
#             Comment=SQLite Studio
#             Exec=${vars.homeDirectory}/app/SQLiteStudio/start.sh
#             Icon=${vars.homeDirectory}/app/SQLiteStudio/ico.png
#             Terminal=false
#             Categories=Utility;Development;
#           '';
#         })
    ])
    (import ./genoc/pkgs/comm.nix { pkgs = pkgs; })
    (import ./genoc/pkgs/cryptocurrency.nix { pkgs = pkgs; })
    (import ./genoc/pkgs/dev.nix { pkgs = pkgs; })
    (import ./genoc/pkgs/editors.nix { pkgs = pkgs; })
    #(import ./genoc/pkgs/fun.nix { pkgs = pkgs; })
    (import ./genoc/pkgs/latex.nix { pkgs = pkgs; })
    (import ./genoc/pkgs/media.nix { pkgs = pkgs; })
    (import ./genoc/pkgs/network_tools.nix { pkgs = pkgs; })
    (import ./genoc/pkgs/nix.nix { pkgs = pkgs; })
    (import ./genoc/pkgs/tools.nix { pkgs = pkgs; })
    #(import ./genoc/pkgs/security.nix { pkgs = pkgs; })
    (import ./genoc/pkgs/sys_tools.nix { pkgs = pkgs; })
  ];
}
