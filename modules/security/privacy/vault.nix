{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    keepassxc # Password manager
    veracrypt # Disk encryption tool
    encfs     # FUSE-based encrypted filesystem
    libfido2
    age-plugin-fido2-hmac
  ];
}
