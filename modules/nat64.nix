{ config, pkgs, lib, self, ... }:
with lib;
let
  cfg = config.nat64;
  cronJob = pkgs.writeShellScript "nat64.sh" ''
    ip rule | grep -F 100.110.0.0/16 || ip rule add from 100.110.0.0/16 table 64
    ip route show table 64 | grep -F default || ip route add default via ${cfg.gateway} table 64

    iptables -C FORWARD -o ${cfg.interface} -d 10.0.0.0/8 -j REJECT || iptables -A FORWARD -o ${cfg.interface} -d 10.0.0.0/8 -j REJECT
    iptables -C FORWARD -o ${cfg.interface} -d 172.16.0.0/12 -j REJECT || iptables -A FORWARD -o ${cfg.interface} -d 172.16.0.0/12 -j REJECT
    iptables -C FORWARD -o ${cfg.interface} -d 192.168.0.0/16 -j REJECT || iptables -A FORWARD -o ${cfg.interface} -d 192.168.0.0/16 -j REJECT
    iptables -C FORWARD -o ${cfg.interface} -d 169.254.0.0/16 -j REJECT || iptables -A FORWARD -o ${cfg.interface} -d 169.254.0.0/16 -j REJECT
    iptables -C FORWARD -o ${cfg.interface} -d 100.64.0.0/10 -j REJECT || iptables -A FORWARD -o ${cfg.interface} -d 100.64.0.0/10 -j REJECT

    iptables -C FORWARD -s 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1300 || iptables -A FORWARD -s 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1300
    iptables -C FORWARD -d 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1300 || iptables -A FORWARD -d 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1300

    iptables -t nat -C POSTROUTING -o ${cfg.interface} -s 100.110.0.0/16 -j SNAT --to-source ${cfg.nat_start}-${cfg.nat_end} || iptables -t nat -A POSTROUTING -o ${cfg.interface} -s 100.110.0.0/16 -j SNAT --to-source ${cfg.nat_start}-${cfg.nat_end}

    # Blacklist
    ## ICMP Flooding @ 20241115
    ip6tables -C FORWARD -d ${cfg.prefix}64::/96 -s 2001:da8::/32 -j REJECT --reject-with icmp6-adm-prohibited || ip6tables -I FORWARD -d ${cfg.prefix}64::/96 -s 2001:da8::/32 -j REJECT --reject-with icmp6-adm-prohibited
    ## SPAM
    ip6tables -C FORWARD -d ${cfg.prefix}64::/96 -p tcp -m multiport --dports 25,110,143,465,587,993,995,2525 -j REJECT --reject-with icmp6-adm-prohibited || ip6tables -I FORWARD -d ${cfg.prefix}64::/96 -p tcp -m multiport --dports 25,110,143,465,587,993,995,2525 -j REJECT --reject-with icmp6-adm-prohibited

    ip6tables -C FORWARD -d ${cfg.prefix}64::/96 -m state --state ESTABLISHED -j ACCEPT || ip6tables -A FORWARD -d ${cfg.prefix}64::/96 -m state --state ESTABLISHED -j ACCEPT
    ip6tables -C FORWARD -d ${cfg.prefix}64::/96 -j LOG --log-prefix "nat64: " || ip6tables -A FORWARD -d ${cfg.prefix}64::/96 -j LOG --log-prefix "nat64: "
  '';
in {
  options.nat64 = {
    enable = mkEnableOption "NAT64 server";
    gateway = mkOption {
      type = types.str;
      description = "IPv4 gateway";
    };
    interface = mkOption {
      type = types.str;
      description = "IPv4 gateway interface";
    };
    nat_start = mkOption {
      type = types.str;
      description = "NAT IPv4 start";
    };
    nat_end = mkOption {
      type = types.str;
      description = "NAT IPv4 end";
    };
    prefix = mkOption {
      type = types.str;
      description = "IPv6 Prefix";
      example = "2602:fab0:2a:";
    };
    address = mkOption {
      type = types.str;
      description = "IPv4 address";
    };
    location = mkOption {
      type = types.str;
      description = "Location";
      example = "mia1";
    };
  };
  config = mkIf cfg.enable {
    # iptables
    environment.systemPackages = with pkgs; [ iptables ];
    # Tayga
    services.tayga = {
      enable = true;
      ipv4 = {
        address = cfg.address;
        router.address = "100.110.0.1";
        pool = {
          address = "100.110.0.0";
          prefixLength = 16;
        };
      };
      ipv6 = {
        address = "${cfg.prefix}:";
        router.address = "${cfg.prefix}64::1";
        pool = {
          address = "${cfg.prefix}64::";
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
            include_matches = { "_TRANSPORT" = [ "kernel" ]; };
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
              . = parse_key_value!(.message)
              .hostname = get_hostname!()
            '';
          };
        };
        sinks = {
          nat64 = {
            type = "http";
            inputs = [ "filter" ];
            uri = "https://o2.esd.cc/api/default/nat64/_json";
            method = "post";
            auth.strategy = "basic";
            auth.user = "\${O2_USER-default}";
            auth.password = "\${O2_PASSWORD-default}";
            compression = "gzip";
            encoding.codec = "json";
            encoding.timestamp_format = "rfc3339";
            healthcheck.enabled = false;
          };
        };
      };
    };
    sops.secrets.openobserve = {
      sopsFile = "${self}/secrets/openobserve.yml";
    };
    systemd.services.vector.serviceConfig = {
      EnvironmentFile = config.sops.secrets.openobserve.path;
      DynamicUser = lib.mkForce false;
    };
    # Crontab
    services.cron = {
      enable = true;
      systemCronJobs = [ "* * * * * root ${cronJob} > /dev/null 2>&1" ];
    };
    # CoreDNS
    networking.interfaces.lo.ipv6.addresses = [{
      address = "${cfg.prefix}53::";
      prefixLength = 128;
    }];
    services.coredns = {
      enable = true;
      package = pkgs.coredns-nat64-rdns;
      config = ''
        . {
          bind ${cfg.prefix}53::
          forward . [2a09::]:53 [2a11::]:53
          dns64 ${cfg.prefix}64::/96
        }
        ${cfg.prefix}64::/96 {
          bind ${cfg.prefix}53::
          nat64-rdns nat64.${cfg.location}.decimallc.com.
        }
      '';
    };
  };
}
