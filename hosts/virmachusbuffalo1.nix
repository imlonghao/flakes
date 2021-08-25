{ modulesPath, pkgs, profiles, self, ... }:
let
  wgPrivKey = (builtins.fromJSON (builtins.readFile "${self}/secrets/wireguard.json")).virmachusbuffalo1;
in
{
  imports = [
    profiles.mycore
    profiles.rait
    profiles.users.root
    profiles.teleport
    profiles.nomad
    profiles.pingfinder
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Config
  networking.dhcpcd.allowInterfaces = [ "ens3" ];
  networking.interfaces.lo.ipv4.addresses = [
    {
      address = "172.22.68.1";
      prefixLength = 32;
    }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    {
      address = "fd21:5c0c:9b7e:1::";
      prefixLength = 64;
    }
  ];

  # hardware-configuration.nix
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };
  swapDevices = [{ device = "/dev/vda2"; }];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # Bird
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.26;
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
            if is_valid_network() then krt_prefsrc = 172.22.68.1;
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
            if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:1::;
            accept;
          };
        };
      }
      protocol static {
        route 172.22.68.0/28 blackhole;
        route 172.22.68.1/32 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        route fd21:5c0c:9b7e:1::/64 blackhole;
        ipv6 {
          import all;
          export all;
        };
      }
      protocol babel gravity {
        ipv4 {
          import all;
          export where net ~ 100.64.88.0/24 || net = 172.22.68.1/32;
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
      protocol bgp AS4242420247 from dnpeers {
        neighbor fe80::247 % 'wg0247' as 4242420247;
      }
      protocol bgp AS4242421080 from dnpeers {
        neighbor fe80::123 % 'wg1080' as 4242421080;
      }
      protocol bgp AS4242421876 from dnpeers {
        neighbor fe80::1876 % 'wg1876' as 4242421876;
      }
      protocol bgp AS4242422547 from dnpeers {
        neighbor fe80::2547 % 'wg2547' as 4242422547;
      }
      protocol bgp AS4242423088 from dnpeers {
        neighbor fe80::3088:194 % 'wg3088' as 4242423088;
      }
      protocol bgp AS4242423914 from dnpeers {
        neighbor fe80::ade0 % 'wg3914' as 4242423914;
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
    address = "100.64.88.25/30";
    addressV6 = "2602:feda:1bf:a:7::1/80";
    hostAddress = "100.64.88.26/30";
    hostAddressV6 = "2602:feda:1bf:a:7::2/80";
  };

  environment.etc."nomad-mutable.hcl".text = ''
    bind_addr = "23.95.222.131"
    client {
      meta = {
        iinomiko = "23.95.222.131"
      }
    }
  '';
  services.nomad.extraSettingsPaths = [ "/etc/nomad-mutable.hcl" ];

  networking.wireguard.interfaces = {
    wg0247 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.250.81/32 dev wg0247";
      privateKey = wgPrivKey;
      listenPort = 20247;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "us1.dn42.as141776.net:41888";
          publicKey = "tRRiOqYhTsygV08ltrWtMkfJxCps1+HUyN4tb1J7Yn4=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
    wg1080 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.229.123/32 dev wg1080";
      privateKey = wgPrivKey;
      listenPort = 21080;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "dn42-us-nyc02.jlu5.com:21888";
          publicKey = "YrlNsVP9bbTqNuNyQ/MVFzulZKNW5vMaDMzHVFNXSSE=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
    wg1876 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.66.53/32 dev wg1876";
      privateKey = wgPrivKey;
      listenPort = 21876;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "n202.dn42.ac.cn:21888";
          publicKey = "EJvoVa5DrJl1rnryF4GThX1Rf86lMBtu2sg8Huru9Gs=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
    wg2547 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.76.190/32 dev wg2547";
      privateKey = wgPrivKey;
      listenPort = 22547;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "virmach-ny1g.lantian.pub:21888";
          publicKey = "a+zL2tDWjwxBXd2bho2OjR/BEmRe2tJF9DHFmZIE+Rk=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
    wg3088 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.21.100.194/32 dev wg3088";
      privateKey = wgPrivKey;
      listenPort = 42050;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "nyc1-us.dn42.6700.cc:21888";
          publicKey = "wAI2D+0GeBnFUqm3xZsfvVlfGQ5iDWI/BykEBbkc62c=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
    wg3914 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.53.98/32 dev wg3914";
      privateKey = wgPrivKey;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "us2.g-load.eu:21888";
          publicKey = "6Cylr9h1xFduAO+5nyXhFI1XJ0+Sw9jCpCDvcqErF1s=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
  };
}
