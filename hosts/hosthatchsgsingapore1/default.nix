{ pkgs, profiles, self, ... }:
let
  wgPrivKey = (builtins.fromJSON (builtins.readFile "${self}/secrets/wireguard.json")).hosthatchsgsingapore1;
in
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.rait
    profiles.pingfinder
  ];

  boot.loader.grub.device = "/dev/vda";
  networking.dhcpcd.allowInterfaces = [ "ens3" ];
  networking.interfaces.lo.ipv4.addresses = [
    {
      address = "172.22.68.2";
      prefixLength = 32;
    }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    {
      address = "fd21:5c0c:9b7e:2::";
      prefixLength = 64;
    }
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/run/secrets"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.62;
      protocol direct {
        ipv4;
        ipv6;
        interface "gravity";
      }
      protocol device {
        scan time 10;
      }
      function is_valid_network() {
        return net ~ [
          172.20.0.0/14{21,29}, # dn42
          172.20.0.0/24{28,32}, # dn42 Anycast
          172.21.0.0/24{28,32}, # dn42 Anycast
          172.22.0.0/24{28,32}, # dn42 Anycast
          172.23.0.0/24{28,32}, # dn42 Anycast
          172.31.0.0/16+,       # ChaosVPN
          10.100.0.0/14+,       # ChaosVPN
          10.127.0.0/16{16,32}, # neonetwork
          10.0.0.0/8{15,24}     # Freifunk.net
        ];
      }
      function is_valid_network_v6() {
        return net ~ [
          fd00::/8{44,64} # ULA address space as per RFC 4193
        ];
      }
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv4 {
          import none;
          export filter {
            if net = 0.0.0.0/0 then reject;
            if is_valid_network() then krt_prefsrc = 172.22.68.2;
            accept;
          };
        };
      }
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv6 {
          import none;
          export filter {
            if net = ::/0 then reject;
            if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:2::;
            accept;
          };
        };
      }
      protocol static {
        route 172.22.68.0/28 blackhole;
        route 172.22.68.2/32 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        route fd21:5c0c:9b7e:2::/64 blackhole;
        ipv6 {
          import all;
          export all;
        };
      }
      protocol babel gravity {
        ipv4 {
          import all;
          export where net ~ 100.64.88.0/24 || net = 172.22.68.2/32;
        };
        ipv6 {
          import all;
          export where net ~ 2602:feda:1bf::/48;
        };
        randomize router id;
        interface "gravity";
      }
      template bgp dnpeers {
        local as 4242421888;
        graceful restart on;
        ipv4 {
          import where is_valid_network();
          export where is_valid_network();
        };
        ipv6 {
          import where is_valid_network_v6();
          export where is_valid_network_v6();
        };
      }
      protocol bgp AS4242420604 from dnpeers {
        neighbor fe80::0604 % 'wg0604' as 4242420604;
      }
      protocol bgp AS4242421876 from dnpeers {
        neighbor fe80::1876 % 'wg1876' as 4242421876;
      }
      protocol bgp ROUTE_COLLECTOR {
        local as 4242421888;
        neighbor fd42:4242:2601:ac12::1 as 4242422602;
        multihop;
        ipv4 {
          add paths tx;
          import none;
          export filter {
            if ( is_valid_network() && source ~ [ RTS_STATIC, RTS_BGP ] )
            then {
              accept;
            }
            reject;
          };
        };
        ipv6 {
          add paths tx;
          import none;
          export filter {
            if ( is_valid_network_v6() && source ~ [ RTS_STATIC, RTS_BGP ] )
            then {
              accept;
            }
            reject;
          };
        };
      }
    '';
  };
  services.gravity = {
    enable = true;
    address = "100.64.88.61/30";
    addressV6 = "2602:feda:1bf:a:10::1/80";
    hostAddress = "100.64.88.62/30";
    hostAddressV6 = "2602:feda:1bf:a:10::2/80";
  };

  networking.wireguard.interfaces = {
    wg0604 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.89.1/32 dev wg0604";
      privateKey = wgPrivKey;
      listenPort = 20604;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sgp1.dn42.cas7.moe:21888";
          publicKey = "R8iyaSzF6xx/t4+1wKlYWZWyZOxJDCXlA2BE3OZnsAY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
    wg1876 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.66.57/32 dev wg1876";
      privateKey = wgPrivKey;
      listenPort = 21876;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "n304.dn42.ac.cn:21888";
          publicKey = "DW2erV/Yv/mFTTeO/zE6JaD83KvxMEu8TkK/3uqryhM=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
  };
}
