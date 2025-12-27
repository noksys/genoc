{ pkgs, ... }:

{
  imports = [
    ../../modules/languages/go/full.nix
    ../../modules/languages/go/tools.nix
    ../../modules/databases/sql/postgres.nix
    ../../modules/virtualization/containers/docker.nix
  ];
}
