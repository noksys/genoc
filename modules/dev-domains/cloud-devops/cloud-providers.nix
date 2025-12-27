{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    awscli2               # Unified tool to manage your AWS services
    google-cloud-sdk      # Tools for the Google Cloud Platform
    azure-cli             # The Azure Command-Line Interface
    # oci-cli             # Oracle Cloud Infrastructure CLI (uncomment if needed)
  ];
}
