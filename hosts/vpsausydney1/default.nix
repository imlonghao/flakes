{ config, pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIB7S04bKMDxbXjfE04+EiHiyP5E6F7+v1EDygUGZGCYZAAAAIPj+1xs73sqX0ReBy336QHxcgCe9v9chEDKjswjGyDXWAAAAAAAAAAAAAAACAAAADHZwc2F1c3lkbmV5MQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZQAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASgAAACEAyB0Z36xiuKJo51w0RIekBxmXAyuNPt6WYTXqsddWSUwAAAAhALBlc+6usdyXE5jvSCb3J0Xk6MH/A02Lu8VpcKPSp3Af";
  cronJob = pkgs.writeShellScript "cron.sh" ''
    # Networking
    #ip -6 rule | grep -F 2a06:a005:b60::/48 || ip -6 rule add from 2a06:a005:b60::/48 table 48
    #ip -6 rule | grep -F "uidrange 993-993" || ip -6 rule add uidrange 993-993 table 48
    #ip -6 route show table 48 | grep -F default || ip -6 route add default via 2a06:a004:101d::1 src 2a06:a005:b60:: table 48
    # GoEdge
    /persist/edge-node/bin/edge-node start
  '';
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    ./dn42.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    profiles.bird-lg-go
    profiles.tuic
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "185.222.217.1";
    defaultGateway6 = "2a11:3:101::1";
    dhcpcd.enable = false;
    interfaces = {
      enp6s18 = {
        ipv4.addresses = [
          { address = "185.222.217.139"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2a11:3:101::105b"; prefixLength = 48; }
        ];
      };
      lo = {
        ipv4.addresses = [
          { address = "172.22.68.0"; prefixLength = 32; }
          { address = "172.22.68.9"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "fd21:5c0c:9b7e:9::"; prefixLength = 64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.22/24";
    ipv6 = "2602:feda:1bf:deaf::22/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * root ${cronJob} > /dev/null 2>&1"
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
    ];
  };

}
