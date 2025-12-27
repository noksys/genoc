{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim # Legendary text editor
    gnumake # Build tool
    postman # API testing tool
    insomnia # API design and testing
    k6 # Load testing tool
  ];
}
