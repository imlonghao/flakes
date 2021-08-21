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
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Config
  networking.dhcpcd.allowInterfaces = [ "ens3" ];

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
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv4 {
          import none;
          export all;
        };
      }
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv6 {
          import none;
          export where net != ::/0;
        };
      }
      protocol static {
        route 172.22.68.0/27 blackhole;
          ipv4 {
            import all;
            export all;
          };
      }
      protocol static {
        route fd21:5c0c:9b7e::/48 blackhole;
        ipv6 {
          import all;
          export all;
        };
      }
      protocol babel gravity {
        ipv4 {
          import all;
          export where net ~ 100.64.88.0/24;
        };
        ipv6 {
          import all;
          export where net ~ 2602:feda:1bf::/48;
        };
        randomize router id;
        interface "gravity";
      }
      protocol bgp AS4242423088 {
        neighbor fe80::3088:194 % 'wg3088' as 4242423088;
        local as 4242421888;
        graceful restart on;
        ipv4 {
            import where net ~ 172.20.0.0/14;
            export where net ~ 172.20.0.0/14;
        };
        ipv6 {
            import where net ~ fd00::/8;
            export where net ~ fd00::/8;
        };
      }
      protocol bgp AS4242423914 {
        neighbor fe80::ade0 % 'wg3914' as 4242423914;
        local as 4242421888;
        graceful restart on;
        ipv4 {
            import where net ~ 172.20.0.0/14;
            export where net ~ 172.20.0.0/14;
        };
        ipv6 {
            import where net ~ fd00::/8;
            export where net ~ fd00::/8;
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
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
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
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
        }
      ];
    };
  };
}
