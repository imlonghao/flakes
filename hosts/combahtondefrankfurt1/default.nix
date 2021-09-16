{ profiles, self, ... }:
let
  vaultToken = builtins.readFile "${self}/secrets/vault.token";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.rait
    profiles.teleport
    profiles.pingfinder
    profiles.k3s
  ];

  networking.dhcpcd.allowInterfaces = [ "ens19" ];
  networking.interfaces.lo.ipv4.addresses = [
    {
      address = "172.22.68.4";
      prefixLength = 32;
    }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    {
      address = "fd21:5c0c:9b7e:4::";
      prefixLength = 64;
    }
  ];

  # rait
  services.gravity = {
    enable = true;
    address = "100.64.88.21/30";
    addressV6 = "2602:feda:1bf:a:6::1/80";
    hostAddress = "100.64.88.22/30";
    hostAddressV6 = "2602:feda:1bf:a:6::2/80";
  };

}
