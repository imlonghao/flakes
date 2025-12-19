{ pkgs, ... }:
{
  services.ranet.iptfs = true;
  # Remove when 6.18 become stable
  boot.kernelPackages = pkgs.linuxPackages_6_16;
}
