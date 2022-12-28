{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dn42;
in
{
  options.dn42 = mkOption {
    type = types.listOf (types.submodule ({
      options.name = mkOption {
        type = types.str;
        description = "name";
      };
      options.ipv6 = mkOption {
        type = types.str;
        description = "ipv6";
        default = "fe80::1888/64";
      };
      options.listen = mkOption {
        type = types.port;
        description = "port";
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
    }));
    description = "internal wireguard interfaces";
    default = [ ];
  };
  config = {
    boot.kernel.sysctl = listToAttrs (map (x: nameValuePair "net.ipv4.conf.${x.name}.rp_filter" 0) cfg);
    networking.wireguard.interfaces = listToAttrs (map
      (x: nameValuePair "${x.name}" {
        ips = [ x.ipv6 ];
        privateKeyFile = config.sops.secrets.wireguard.path;
        listenPort = x.listen;
        allowedIPsAsRoutes = false;
        peers = [
          {
            endpoint = x.endpoint;
            publicKey = x.publickey;
            allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
          }
        ];
      })
      cfg);
  };
}
