{
  config,
  pkgs,
  self,
  ...
}:
let
  cronJob = pkgs.writeShellScript "cron.sh" ''
    # Networking
    ip -6 rule | grep -F 2602:fab0:26:1::/64 || ip -6 rule add from 2602:fab0:26:1::/64 table 48
    ip -6 rule | grep -F "uidrange 993-993" || ip -6 rule add uidrange 993-993 table 48
    ip -6 rule | grep -F 2a11:3:101::105b || ip -6 rule add from 2a11:3:101::105b lookup main
    ip -6 route show table 48 | grep -F default || ip -6 route add default via 2602:feda:1bf:deaf::33 src 2602:fab0:26:1:: table 48
  '';
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    ./dn42.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/pingfinder"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/exporter/bird.nix"
    "${self}/profiles/exporter/blackbox.nix"
    "${self}/profiles/bird-lg-go"
    "${self}/profiles/sing-box"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/docker"
    "${self}/profiles/k3s/agent.nix"
    "${self}/profiles/komari-agent"
  ];

  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    defaultGateway = "185.222.217.1";
    defaultGateway6 = "2a11:3:101::1";
    dhcpcd.enable = false;
    interfaces = {
      enp6s18 = {
        ipv4.addresses = [
          {
            address = "185.222.217.139";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a11:3:101::105b";
            prefixLength = 48;
          }
        ];
      };
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.0";
            prefixLength = 32;
          }
          {
            address = "172.22.68.9";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:9::1";
            prefixLength = 64;
          }
          {
            address = "2602:fab0:26:1::";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [ "* * * * * root ${cronJob} > /dev/null 2>&1" ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "enp6s18";
    id = 8;
  };

  services.komari-agent = {
    month-rotate = 1;
    include-nics = [ "enp6s18" ];
  };

}
