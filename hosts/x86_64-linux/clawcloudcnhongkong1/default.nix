{ self, pkgs, ... }:
{
  imports = [
    ./dn42.nix
    ./bird.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/exporter/blackbox.nix"
    "${self}/profiles/rsshc"
    "${self}/profiles/pingfinder"
    "${self}/profiles/docker"
    "${self}/profiles/bird-lg-go"
    "${self}/profiles/k3s/agent.nix"
  ];

  networking = {
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.0";
            prefixLength = 32;
          }
          {
            address = "172.22.68.3";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:3::1";
            prefixLength = 64;
          }
        ];
      };
    };
    dhcpcd.allowInterfaces = [ "ens5" ];
  };

  # Realm
  services.realm = {
    enable = true;
    config = {
      endpoints = [
        {
          listen = "0.0.0.0:443";
          remote = "157.254.178.55:443";
          network = {
            no_tcp = true;
            use_udp = true;
          };
        }
        {
          listen = "0.0.0.0:8443";
          remote = "103.147.22.112:443";
          network = {
            no_tcp = true;
            use_udp = true;
          };
        }
        {
          listen = "0.0.0.0:3389";
          remote = "157.254.178.55:9102";
        }
      ];
    };
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens5";
    id = 14;
  };

}
