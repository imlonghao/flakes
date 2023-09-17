{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIHZyYey1LCcKRsYerHf9w2B1irnK2jNaXn2b74J3H8mqAAAAIBSOTtTAYSdlCTVNwjmE5DU6NVSPiyoPcN6Y+i6/4qFSAAAAAAAAAAAAAAACAAAADWJ1eXZtdXNtaWFtaTEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGUAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEoAAAAhAIS5SJ2iqDirsAHpOdVc4R1unc8s5Hjp/qkI1UzS1TRaAAAAIQD6un0t6ejrn9ztVoOwf8ou6i/woUnAChietrc12ScGyQ==";
  cronJob = pkgs.writeShellScript "cron.sh" ''
    # Networking
    ip rule | grep -F 100.110.0.0/16 || ip rule add from 100.110.0.0/16 table 64
    ip route show table 64 | grep -F default || ip route add default via 45.61.188.1 table 64

    iptables -C FORWARD -o ens3 -d 10.0.0.0/8 -j REJECT || iptables -A FORWARD -o ens3 -d 10.0.0.0/8 -j REJECT
    iptables -C FORWARD -o ens3 -d 172.16.0.0/12 -j REJECT || iptables -A FORWARD -o ens3 -d 172.16.0.0/12 -j REJECT
    iptables -C FORWARD -o ens3 -d 192.168.0.0/16 -j REJECT || iptables -A FORWARD -o ens3 -d 192.168.0.0/16 -j REJECT
    iptables -C FORWARD -o ens3 -d 169.254.0.0/16 -j REJECT || iptables -A FORWARD -o ens3 -d 169.254.0.0/16 -j REJECT
    iptables -C FORWARD -o ens3 -d 100.64.0.0/10 -j REJECT || iptables -A FORWARD -o ens3 -d 100.64.0.0/10 -j REJECT

    iptables -C FORWARD -s 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200 || iptables -A FORWARD -s 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200
    iptables -C FORWARD -d 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200 || iptables -A FORWARD -d 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200

    iptables -t nat -C POSTROUTING -o ens3 -s 100.110.0.0/16 -j SNAT --to-source 23.146.88.248-23.146.88.255 || iptables -t nat -A POSTROUTING -o ens3 -s 100.110.0.0/16 -j SNAT --to-source 23.146.88.248-23.146.88.255

    ip6tables -C FORWARD -d 2602:fab0:2a:64::/96 -m state --state ESTABLISHED -j ACCEPT || ip6tables -A FORWARD -d 2602:fab0:2a:64::/96 -m state --state ESTABLISHED -j ACCEPT
    ip6tables -C FORWARD -d 2602:fab0:2a:64::/96 -j LOG --log-prefix "nat64: " || ip6tables -A FORWARD -d 2602:fab0:2a:64::/96 -j LOG --log-prefix "nat64: "
    ip6tables -C FORWARD -d 2602:fab0:2a:64::/96 -p tcp -m multiport --dports 25,110,143,465,587,993,995,2525 -j REJECT --reject-with icmp6-adm-prohibited || ip6tables -A FORWARD -d 2602:fab0:2a:64::/96 -p tcp -m multiport --dports 25,110,143,465,587,993,995,2525 -j REJECT --reject-with icmp6-adm-prohibited
  '';
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    # ./wireguard.nix
    profiles.mycore
    profiles.users.root
    # profiles.pingfinder
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.mtrsb
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "45.61.188.1";
    defaultGateway6 = "2605:6400:40::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      lo.ipv4.addresses = [
        { address = "23.146.88.0"; prefixLength = 32; }
        { address = "23.146.88.1"; prefixLength = 32; }
      ];
      lo.ipv6.addresses = [
        { address = "2602:fab0:20::"; prefixLength = 128; }
        { address = "2602:fab0:2a::"; prefixLength = 128; }
        { address = "2602:fab0:2a:53::"; prefixLength = 128; }
      ];
      ens3.ipv4.addresses = [
        { address = "45.61.188.76"; prefixLength = 24; }
      ];
      ens3.ipv6.addresses = [
        { address = "2605:6400:40:fdeb::"; prefixLength = 48; }
      ];
    };
  };

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
  environment.systemPackages = with pkgs; [
    iptables
  ];

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.70/24";
    ipv6 = "2602:feda:1bf:deaf::3/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # Tayga
  services.tayga = {
    enable = true;
    ipv4 = {
      address = "23.146.88.1";
      router.address = "100.110.0.1";
      pool = {
        address = "100.110.0.0";
        prefixLength = 16;
      };
    };
    ipv6 = {
      address = "2602:fab0:2a::";
      router.address = "2602:fab0:2a:64::1";
      pool = {
        address = "2602:fab0:2a:64::";
        prefixLength = 96;
      };
    };
  };

  # Vector
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources = {
        kernel = {
          type = "journald";
          include_matches = {
            "_TRANSPORT" = [ "kernel" ];
          };
        };
      };
      transforms = {
        filter = {
          type = "remap";
          inputs = [ "kernel" ];
          source = ''
            .message = string!(.message)
            if !starts_with(.message, "nat64: ") {
              abort
            }
            .message = replace(.message, r'nat64: ', "")
            .message = replace(.message, r' $', "")
            .payload = parse_key_value!(.message)
            .report_type = "nat64"
            del(.message)
          '';
        };
      };
      sinks = {
        nr = {
          type = "new_relic";
          inputs = [ "filter" ];
          account_id = "\${NEW_RELIC_ACCOUNT_ID}";
          license_key = "\${NEW_RELIC_LICENSE_KEY}";
          api = "logs";
        };
      };
    };
  };
  sops.secrets.vector = {
    sopsFile = "${self}/secrets/vector.yml";
  };
  systemd.services.vector.serviceConfig.EnvironmentFile = config.sops.secrets.vector.path;

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * root ${cronJob} > /dev/null 2>&1"
    ];
  };

  # CoreDNS
  services.coredns = {
    enable = true;
    package = pkgs.coredns-nat64-rdns;
    config = ''
      . {
        bind 2602:fab0:2a:53::
        forward . [2a09::]:53 [2a11::]:53
        dns64 2602:fab0:2a:64::/96
      }
      2602:fab0:2a:64::/96 {
        bind 2602:fab0:2a:53::
        nat64-rdns nat64.mia1.decimallc.com.
      }
    '';
  };

}
