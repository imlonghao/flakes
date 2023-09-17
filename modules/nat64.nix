{ config, pkgs, lib, ... }:
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

    iptables -C FORWARD -s 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200 || iptables -A FORWARD -s 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200
    iptables -C FORWARD -d 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200 || iptables -A FORWARD -d 100.110.0.0/16 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200

    iptables -t nat -C POSTROUTING -o ${cfg.interface} -s 100.110.0.0/16 -j SNAT --to-source ${cfg.nat_start}-${cfg.nat_end} || iptables -t nat -A POSTROUTING -o ${cfg.interface} -s 100.110.0.0/16 -j SNAT --to-source ${cfg.nat_start}-${cfg.nat_end}

    ip6tables -C FORWARD -d ${cfg.prefix}64::/96 -m state --state ESTABLISHED -j ACCEPT || ip6tables -A FORWARD -d ${cfg.prefix}64::/96 -m state --state ESTABLISHED -j ACCEPT
    ip6tables -C FORWARD -d ${cfg.prefix}64::/96 -j LOG --log-prefix "nat64: " || ip6tables -A FORWARD -d ${cfg.prefix}64::/96 -j LOG --log-prefix "nat64: "
    ip6tables -C FORWARD -d ${cfg.prefix}64::/96 -p tcp -m multiport --dports 25,110,143,465,587,993,995,2525 -j REJECT --reject-with icmp6-adm-prohibited || ip6tables -A FORWARD -d ${cfg.prefix}64::/96 -p tcp -m multiport --dports 25,110,143,465,587,993,995,2525 -j REJECT --reject-with icmp6-adm-prohibited
  '';
in
{
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
    # Secrets
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
