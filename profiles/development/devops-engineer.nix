{ pkgs, ... }:

{
  imports = [
    ../../modules/dev-domains/cloud-devops/k8s-full.nix
    ../../modules/dev-domains/cloud-devops/iac.nix
    ../../modules/dev-domains/cloud-devops/cloud-providers.nix
  ];
}
