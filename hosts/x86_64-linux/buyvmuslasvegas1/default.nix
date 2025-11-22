{ self, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./dn42.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/pingfinder"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/exporter/bird.nix"
    "${self}/profiles/bird-lg-go"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/komari-agent"
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    defaultGateway6 = "2605:6400:20::1";
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    interfaces = {
      lo.ipv4.addresses = [
        {
          address = "172.22.68.5";
          prefixLength = 32;
        }
        {
          address = "23.146.88.0";
          prefixLength = 32;
        }
        {
          address = "23.146.88.3";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:5::1";
          prefixLength = 128;
        }
        {
          address = "2602:fab0:20::";
          prefixLength = 128;
        }
        {
          address = "2602:fab0:29::1";
          prefixLength = 128;
        }
        {
          address = "2602:fab0:29::123";
          prefixLength = 128;
        }
      ];
      ens3.ipv6.addresses = [
        {
          address = "2605:6400:20:803::";
          prefixLength = 48;
        }
      ];
    };
  };

  environment.persistence."/persist" = {
    directories = [ "/var/lib" ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # chrony
  services.chrony = {
    servers = [
      "ntp.netviscom.com"
      "time-clock.borgnet.us"
      "time-b.intt.org"
      "clock.sjc.he.net"
      "clock.fmt.he.net"
    ];
    extraConfig = ''
      bindaddress 2602:fab0:29::123
      allow ::/0
    '';
  };
  services.chrony_exporter = {
    enable = true;
    listen = "[2602:fab0:29::123]:9000";
  };

  # NAT64
  nat64 = {
    enable = true;
    gateway = "199.19.224.1";
    interface = "ens3";
    nat_start = "23.146.88.240";
    nat_end = "23.146.88.247";
    prefix = "2602:fab0:29:";
    address = "23.146.88.3";
    location = "las1";
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens3";
    ipv6 = false;
    mtu = 1440;
    id = 6;
  };

  # komari-agent
  services.komari-agent = {
    include-nics = [ "ens3" ];
  };

}
