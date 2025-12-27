{ pkgs, ... }:
{
  imports = [ ./k8s-base.nix ];

  environment.systemPackages = with pkgs; [
    helm                  # The Kubernetes Package Manager
    k9s                   # Kubernetes CLI To Manage Your Clusters In Style
    kind                  # Kubernetes IN Docker
    kubectx               # Fast way to switch between clusters and namespaces
    stern                 # Multi pod and container log tailing for Kubernetes
  ];
}
