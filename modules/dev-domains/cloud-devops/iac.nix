{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    terraform             # Infrastructure is data
    opentofu              # Open Source alternative to Terraform
    ansible               # Radically simple IT automation
    vagrant               # Tool for building and distributing development environments
    packer                # Tool for creating identical machine images for multiple platforms
  ];
}
