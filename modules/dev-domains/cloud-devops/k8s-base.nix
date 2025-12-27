{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kubectl               # Kubernetes CLI
    minikube              # Run Kubernetes locally
  ];
}
