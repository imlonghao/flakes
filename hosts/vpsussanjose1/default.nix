{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAINlOFTukyWFrgNHPdj1QQX1BypH8xF2njCrfgnMhC8oOAAAAIL7X+FLYX1M6gfSxUlZL91SHYTbFcExJSPbREgV8ZbplAAAAAAAAAAAAAAACAAAADXZwc3Vzc2Fuam9zZTEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGQAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEkAAAAhAL0OzIbJq53sxb7w+NpbWSrnchjxLfe5+wqURHUmoJfVAAAAIAYlMT5cr7tuLxo6010pv+zdgxzPRjcbvxccnIh1Ua3Y";
  cronJob = pkgs.writeShellScript "cron.sh" ''
    # Networking
    ip -6 rule | grep -F 2602:fab0:11::/48 || ip -6 rule add from 2602:fab0:11::/48 table 2602
    ip -6 route show table 2602 | grep -F default || ip -6 route add default via 2604:a840:2::4 table 2602
  '';
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "45.139.193.1";
    defaultGateway6 = "2604:a840:2::1";
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "45.139.193.138"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2604:a840:2::157"; prefixLength = 48; }
        ];
      };
      lo = {
        ipv6.addresses = [
          { address = "2602:feda:1bf::"; prefixLength = 128; }
          { address = "2602:fab0:11::"; prefixLength = 128; }
        ];
      };
    };
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.25/24";
    ipv6 = "2602:feda:1bf:deaf::25/64";
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * root ${cronJob} > /dev/null 2>&1"
    ];
  };

}
