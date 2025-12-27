{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kubectl               # Kubernetes CLI
    helm                  # The Kubernetes Package Manager
    k9s                   # Kubernetes CLI To Manage Your Clusters In Style
    minikube              # Run Kubernetes locally
    kind                  # Kubernetes IN Docker
    kubectx               # Fast way to switch between clusters and namespaces
  ];
}
