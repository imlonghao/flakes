{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dn42;
in {
  options.dn42 = mkOption {
    type = types.listOf (types.submodule ({
      options.name = mkOption {
        type = types.str;
        description = "name";
      };
      options.ipv4 = mkOption {
        type = types.str;
        description = "ipv4";
        default = "172.22.68.0";
      };
      options.ipv6 = mkOption {
        type = types.str;
        description = "ipv6";
        default = "fe80::1888/64";
      };
      options.listen = mkOption {
        type = types.nullOr types.port;
        description = "port";
        default = null;
      };
      options.endpoint = mkOption {
        type = types.nullOr types.str;
        description = "endpoint";
        default = null;
      };
      options.publickey = mkOption {
        type = types.str;
        description = "publickey";
      };
      options.presharedkey = mkOption {
        type = types.nullOr types.str;
        description = "presharedkey";
        default = null;
      };
      options.asn = mkOption {
        type = types.int;
        description = "asn";
      };
      options.e4 = mkOption {
        type = types.nullOr types.str;
        description = "endpoint IPv4";
        default = null;
      };
      options.e6 = mkOption {
        type = types.nullOr types.str;
        description = "endpoint IPv6";
        default = null;
      };
      options.mpbgp = mkOption {
        type = types.bool;
        description = "support Multiprotocol BGP";
        default = true;
      };
      options.l4 = mkOption {
        type = types.nullOr types.str;
        description = "local IPv4 address";
        default = null;
      };
      options.mtu = mkOption {
        type = types.nullOr types.int;
        description = "mtu";
        default = null;
      };
    }));
    description = "internal wireguard interfaces";
    default = [ ];
  };
  config = {
    boot.kernel.sysctl = listToAttrs
      (map (x: nameValuePair "net.ipv4.conf.${x.name}.rp_filter" 0) cfg);
    networking.wireguard.interfaces = listToAttrs (map (x:
      nameValuePair "${x.name}" {
        ips = [ x.ipv6 ];
        mtu = mkIf (x.mtu != null) x.mtu;
        postSetup = mkIf (x.e4 != null) [
          "${pkgs.iproute2}/bin/ip addr add ${x.ipv4}/32 peer ${x.e4}/32 dev ${x.name}"
          "${pkgs.iproute2}/bin/ip route change ${x.e4} src ${x.l4} dev ${x.name}"
        ];
        privateKeyFile = config.sops.secrets.wireguard.path;
        listenPort = x.listen;
        allowedIPsAsRoutes = false;
        peers = [{
          endpoint = x.endpoint;
          publicKey = x.publickey;
          presharedKey = x.presharedkey;
          allowedIPs = [
            "10.0.0.0/8"
            "172.20.0.0/14"
            "172.31.0.0/16"
            "fe80::/64"
            "fd00::/8"
          ];
        }];
      }) cfg);
  };
}
