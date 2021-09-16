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

  # Nomad Server
  networking.nameservers = [ "127.0.0.1" "1.1.1.1" "8.8.8.8" ];
  services.coredns = {
    enable = true;
    config = ''
      . {
        bind 127.0.0.1
        forward . 1.1.1.1:53 8.8.8.8:53 1.0.0.1:53 8.8.4.4:53
      }
      consul {
        bind 127.0.0.1
        cache 30
        forward . 127.0.0.1:8600
      }
    '';
  };
  services.consul = {
    enable = true;
    interface.bind = "gravity";
    extraConfig = {
      server = true;
    };
  };
  services.nomad = {
    enable = true;
    settings = {
      bind_addr = "100.64.88.22";
      leave_on_interrupt = true;
      leave_on_terminate = true;
      disable_update_check = true;
      datacenter = "dc";
      acl = {
        enabled = true;
      };
      server = {
        enabled = true;
      };
      vault = {
        enabled = true;
        address = "http://vault.service.consul:8200";
        create_from_role = "nomad-cluster";
        token = vaultToken;
      };
    };
  };

}
