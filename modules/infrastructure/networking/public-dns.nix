{ config, lib, pkgs, ... }:
{
  # Standard Public Nameservers
  # 1.1.1.1 (Cloudflare)
  # 8.8.8.8 (Google)
  # 9.9.9.9 (Quad9)
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" "9.9.9.9" ];
}
